#include <zoe_renderer.h>
#include <input/map.h>
#include <input/keycodes.h>
#include <metal_kit_shader_types.h>

#include <clic3.h>

#include <MetalKit/MetalKit.h>
#include <simd/simd.h>

static const unsigned int max_buffers_in_flight = 3;
static const unsigned int length_buffers_visibility = max_buffers_in_flight + 1;

@implementation zoe_renderer {
  dispatch_semaphore_t semaphore_in_flight;
  
  id<MTLBuffer> buffer_visibility[length_buffers_visibility];
  id<MTLBuffer> data_buffer_frame[max_buffers_in_flight];
  id<MTLBuffer> index_buffer_mesh_current;
  id<MTLBuffer> indices_icosahedron;
  id<MTLBuffer> vertices_icosahedron;

  id<MTLBuffer> indices_ground;
  id<MTLBuffer> vertices_ground;

  id<MTLCommandQueue> command_queue;

  id<MTLDevice> metal_kit_device;

  id<MTLDepthStencilState> depth_state;
  id<MTLDepthStencilState> depth_state_writes_disable;

  id<MTLRenderCommandEncoder> encoder_render;

  id<MTLRenderPipelineState> state_pipeline;
  id<MTLRenderPipelineState> state_pipeline_no_render;

  id<MTLTexture> texture;

  MTLVertexDescriptor* metal_descriptor_vertex;

  // clic3_matrix4x4_float matrix_projection;
  matrix_float4x4 matrix_projection;
  
  struct clic3_vector3_float position_user;

  struct clic3_vector3_unsigned_int size_viewport;

  float speed_input;

  unsigned char index_data_buffer_frame;
  uint64_t* buffer_result_visibility_from_read;
  
  unsigned int frame;
  unsigned int index_buffer_visibility_read;
  unsigned int index_buffer_visibility_write;
  unsigned int length_index_icosahedron;
  unsigned int length_index_ground;
}

- (nonnull instancetype) initWithMetalKitView: (nonnull MTKView*) metal_kit_view {
  self = [super init];

  if (!self) {
    return self;
  }

  metal_kit_device = metal_kit_view.device;

  semaphore_in_flight = dispatch_semaphore_create(
    max_buffers_in_flight
  );

  metal_kit_view.depthStencilPixelFormat = MTLPixelFormatDepth32Float_Stencil8;
  metal_kit_view.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
  metal_kit_view.sampleCount = 1;

  position_user.x = 0.0f;
  position_user.y = 0.0f;
  position_user.z = 0.0f;

  speed_input = 0.1f;

  id<MTLLibrary> library_default = [metal_kit_device newDefaultLibrary];
  id<MTLFunction> function_vertex = [library_default newFunctionWithName: @"zoe_shader_vertex"];
  id<MTLFunction> function_fragment = [library_default newFunctionWithName: @"zoe_shader_fragment"];

  MTLRenderPipelineDescriptor* descriptor_state_pipeline = [[MTLRenderPipelineDescriptor alloc] init];
  descriptor_state_pipeline.rasterSampleCount = metal_kit_view.sampleCount;
  descriptor_state_pipeline.vertexFunction = function_vertex;
  descriptor_state_pipeline.fragmentFunction = function_fragment;
  descriptor_state_pipeline.colorAttachments[0].pixelFormat = metal_kit_view.colorPixelFormat;
  descriptor_state_pipeline.depthAttachmentPixelFormat = metal_kit_view.depthStencilPixelFormat;
  descriptor_state_pipeline.stencilAttachmentPixelFormat = metal_kit_view.depthStencilPixelFormat;

  state_pipeline = [metal_kit_device
    newRenderPipelineStateWithDescriptor: descriptor_state_pipeline
    error: (void*)0
  ];
  descriptor_state_pipeline.fragmentFunction = (void*)0;

  state_pipeline_no_render = [metal_kit_device
    newRenderPipelineStateWithDescriptor: descriptor_state_pipeline
    error: (void*)0
  ];

  MTLDepthStencilDescriptor* descriptor_state_depth = [[MTLDepthStencilDescriptor alloc] init];
  descriptor_state_depth.depthCompareFunction = MTLCompareFunctionLessEqual;
  descriptor_state_depth.depthWriteEnabled = 1;
  depth_state = [metal_kit_device newDepthStencilStateWithDescriptor:descriptor_state_depth];

  descriptor_state_depth.depthWriteEnabled = 0;
  depth_state_writes_disable = [metal_kit_device newDepthStencilStateWithDescriptor: descriptor_state_depth];

  for (
    unsigned int index_buffer = 0;
    index_buffer < max_buffers_in_flight;
    ++index_buffer
  ) {
    data_buffer_frame[
      index_buffer
    ] = [metal_kit_device
      newBufferWithLength: sizeof(metal_kit_data_frame)
      options:MTLResourceStorageModeShared
    ];
  }

  command_queue = [metal_kit_device newCommandQueue];

  for (
    unsigned int index_buffer = 0;
    index_buffer < length_buffers_visibility;
    ++index_buffer
  ) {
    buffer_visibility[
      index_buffer
    ] = [metal_kit_device
      newBufferWithLength: length_objects_xyz * sizeof(uint64_t)
      options: MTLResourceStorageModeShared
    ];
  }

  struct clic3_vector3_float size_ground_min = {
    .x = -10.0f,
    .y = 0.0f,
    .z = -10.0f
  };

  struct clic3_vector3_float size_ground_max = {
    .x = 10.0f,
    .y = 0.2345f,
    .z = 10.0f
  };

  struct clic3_vector3_float range_ground = {
    .x = size_ground_max.x - size_ground_min.x,
    .y = size_ground_max.y - size_ground_min.y,
    .z = size_ground_max.z - size_ground_min.z
  };

  struct clic3_vector2_unsigned_char length_vertices_ground = {
    .x = 10,
    .y = 10
  };

  unsigned char length_total_vertices_ground = (
    length_vertices_ground.x *
    length_vertices_ground.y
  );

  struct clic3_vector4_float _vertices_ground[length_total_vertices_ground];

  unsigned int index_vertex_ground = 0;
  for (
    float index_x = size_ground_min.x;
    index_x < size_ground_max.x;
    index_x = (
      index_x + range_ground.x / (
        (float) length_total_vertices_ground / 10.0f
      )
    )
  ) {
    for (
      float index_z = size_ground_min.z;
      index_z < size_ground_max.z;
      index_z = (
        index_z + range_ground.z / (
          (float) length_total_vertices_ground / 10.0f
        )
      )
    ) {
      _vertices_ground[index_vertex_ground].x = index_x;
      _vertices_ground[index_vertex_ground].y = size_ground_min.y + (float)(rand() % 1000) / 1000.0f * range_ground.y;
      _vertices_ground[index_vertex_ground].z = index_z;
      _vertices_ground[index_vertex_ground].w = 1.0f;

      index_vertex_ground = (
        index_vertex_ground + 1
      );
    }
  }

  uint32_t _indices_ground[length_total_vertices_ground] = {};

  index_vertex_ground = 0;
  for (
    float index_x = size_ground_min.x;
    index_x < size_ground_max.x;
    index_x = (
      index_x + range_ground.x / (
        (float) length_total_vertices_ground / 10.0f
      )
    )
  ) {
    for (
      float index_z = size_ground_min.z;
      index_z < size_ground_max.z;
      index_z = (
        index_z + range_ground.z / (
          (float) length_total_vertices_ground / 10.0f
        )
      )
    ) {
      _indices_ground[index_vertex_ground] = index_vertex_ground * 242 % 100;

      index_vertex_ground = (
        index_vertex_ground + 1
      );
    }
  }

  length_index_ground = (
    sizeof(_indices_ground) /
    sizeof(uint32_t)
  );

  vertices_ground = [metal_kit_device
    newBufferWithBytes: _vertices_ground
    length: sizeof(vertices_ground)
    options: MTLResourceStorageModeShared
  ];

  indices_ground = [metal_kit_device
    newBufferWithBytes: _indices_ground
    length: sizeof(_indices_ground)
    options: MTLResourceStorageModeShared
  ];

  const float radius_sphere = 0.7f;
  const float radius = 4.0f * radius_sphere;

  float segment = 0.3f;

  vector_float4 icosahedronVertices[] = {
    { -segment, -segment, segment, 1.0f },
    { segment, -segment, segment, 1.0f },
    { -segment, -segment, -segment, 1.0f },
    { segment, -segment, -segment, 1.0f },
    { -segment, segment, segment, 1.0f },
    { segment, segment, segment, 1.0f },
    { -segment, segment, -segment, 1.0f },
    { segment, segment, -segment, 1.0f },
  };

  uint32_t icosahedronIndices[] = {
    0, 1, 2,
    2, 1, 3,
    4, 5, 6,
    6, 5, 7,
    6, 2, 0,
    6, 0, 4,
    2, 3, 6,
    7, 6, 3,
    7, 3, 1,
    7, 1, 5,
    0, 1, 4,
    5, 4, 1,
  };

  length_index_icosahedron = (
    sizeof(icosahedronIndices) /
    sizeof(uint32_t)
  );

  vertices_icosahedron = [metal_kit_device
    newBufferWithBytes: icosahedronVertices
    length: sizeof(icosahedronVertices)
    options: MTLResourceStorageModeShared
  ];

  indices_icosahedron = [metal_kit_device
    newBufferWithBytes: icosahedronIndices
    length: sizeof(icosahedronIndices)
    options: MTLResourceStorageModeShared
  ];

  unsigned short int height = 10;
  unsigned short int width = 10;
  unsigned short int pixels = height * width;

  unsigned char* data_image = malloc(
    sizeof(unsigned char) * pixels * 4
  );

  for (
    unsigned short int y = 0;
    y < height;
    y++
  ) {
    for (
      unsigned short int x = 0;
      x < width;
      x++
    ) {
      unsigned short int index = (
        (y * width + x) * 4
      );

      float value = (float)(x + y) / (float)(height + width) * 255.0f;

      data_image[index] = (x + y) % 2 == 1 ? value : 0;
      data_image[index + 1] = (x + y) % 3 == 0 ? value : 0;
      data_image[index + 2] = (x + y) % 2 == 0 ? value : 0;
      data_image[index + 3] = 255;
    }
  }

  MTLTextureDescriptor* descriptor_texture = [[MTLTextureDescriptor alloc] init];
  descriptor_texture.pixelFormat = MTLPixelFormatBGRA8Unorm;
  descriptor_texture.height = height;
  descriptor_texture.width = width;

  texture = [metal_kit_device newTextureWithDescriptor: descriptor_texture];

  MTLRegion region_texture = {
    {
      .x = 0,
      .y = 0,
      .z = 0
    },
    {
      .width = width,
      .height = height,
      .depth = 1
    }
  };

  [texture replaceRegion: region_texture
    mipmapLevel: 0
    withBytes: data_image
    bytesPerRow: width * 4
  ];

  free(data_image);

  return self;
}

- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view {
  if (
    input_map_keydown[
      keycode_up_arrow
    ] == 1
  ) {
    position_user.y -= speed_input;
  }

  if (
    input_map_keydown[
      keycode_down_arrow
    ] == 1
  ) {
    position_user.y += speed_input;
  }

  if (
    input_map_keydown[
      keycode_left_arrow
    ] == 1
  ) {
    position_user.x += speed_input;
  }

  if (
    input_map_keydown[
      keycode_right_arrow
    ] == 1
  ) {
    position_user.x -= speed_input;
  }

  dispatch_semaphore_wait(
    semaphore_in_flight,
    DISPATCH_TIME_FOREVER
  );

  index_data_buffer_frame = (index_data_buffer_frame + 1) % max_buffers_in_flight;
  index_buffer_visibility_write = (
    index_buffer_visibility_write + 1
  ) % length_buffers_visibility;

  buffer_result_visibility_from_read = buffer_visibility[index_buffer_visibility_read].contents;

  MTLRenderPassDescriptor* descriptor_render_pass = metal_kit_view.currentRenderPassDescriptor;
  descriptor_render_pass.colorAttachments[0].clearColor = MTLClearColorMake(
    0.003849f,
    0.000324f,
    0.018349f,
    1.0f
  );

  descriptor_render_pass.visibilityResultBuffer = buffer_visibility[index_buffer_visibility_write];

  id<MTLCommandBuffer> command_buffer = [command_queue commandBuffer];
  encoder_render = [command_buffer renderCommandEncoderWithDescriptor: descriptor_render_pass];

  [encoder_render setRenderPipelineState: state_pipeline];
  [encoder_render setDepthStencilState: depth_state];

  [self updateOcclusionCulling];
  [self renderMainRenderPass];

  [encoder_render endEncoding];

  __block dispatch_semaphore_t block_semaphore = semaphore_in_flight;

  [command_buffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
    self->index_buffer_visibility_read = (
      self->index_buffer_visibility_read + 1
    ) % length_buffers_visibility;

    dispatch_semaphore_signal(block_semaphore);
  }];

  [command_buffer presentDrawable: metal_kit_view.currentDrawable];
  [command_buffer commit];
}

- (void) mtkView: (nonnull MTKView*) metal_kit_view drawableSizeWillChange: (CGSize) size {
  size_viewport.x = size.width;
  size_viewport.y = size.height;
}

- (void) updateOcclusionCulling {
  const unsigned int _frame = frame++;
  const float max_value = 3.33f;

  if (frame >= UINT_MAX) {
    frame = 0;
  }

  const struct clic3_vector3_float center_grid = {
    .x = (float)(length_objects_x - 1) / 2.0f,
    .y = (float)(length_objects_y - 1) / 2.0f,
    .z = (float)(length_objects_z - 1) * (_frame % 2 == 0 ? 2.0f : -2.0f)
  };

  const struct clic3_vector3_float scale_grid = {
    .x = 1.0f,
    .y = 1.0f,
    .z = _frame % 2 == 0 ? 1.0f : -1.0f
  };

  metal_kit_data_frame* data_frame = (data_buffer_frame[index_data_buffer_frame]).contents;
  unsigned int index_object = 0;

  for (
    int index_z = 0;
    index_z < length_objects_z;
    ++index_z
  ) {
    for (
      int index_y = 0;
      index_y < length_objects_y;
      ++index_y
    ) {
      for (
        int index_x = 0;
        index_x < length_objects_x;
        ++index_x
      ) {
        struct clic3_vector3_float position = {
          .x = ((index_x + position_user.x - center_grid.x) * scale_grid.x),
          .y = ((index_y + position_user.y - center_grid.y) * scale_grid.y),
          .z = ((index_z + position_user.z - center_grid.z) * scale_grid.z)
        };

        matrix_float4x4 matrix_model_view = (matrix_float4x4) {{
          { 1, 0, 0, 0 },
          { 0, 1, 0, 0 },
          { 0, 0, 1, 0 },
          { position.x, position.y, position.z, 1 }
        }};

        data_frame->objects[index_object].view_model_matrix_projection = matrix_multiply(
          matrix_projection,
          matrix_model_view
        );

        ++index_object;
      }
    }
  }
}

- (void) renderMainRenderPass {
  [encoder_render
    setVertexBuffer: data_buffer_frame[index_data_buffer_frame]
    offset: 0
    atIndex: metal_kit_vertex_input_index_frame_data
  ];

  [encoder_render
    setFragmentTexture: texture
    atIndex: 1
  ];

  [encoder_render
    setVertexBuffer: vertices_ground
    offset: 0
    atIndex: metal_kit_vertex_input_index_positions
  ];

  unsigned int i = 0;
  [encoder_render
    setVertexBytes: &i
    length: sizeof(unsigned int)
    atIndex: metal_kit_vertex_input_index_mesh_index
  ];
  
  [encoder_render
    drawIndexedPrimitives: MTLPrimitiveTypePoint
    indexCount: length_index_ground
    indexType: MTLIndexTypeUInt32
    indexBuffer: indices_ground
    indexBufferOffset: 0
  ];


  [encoder_render
    setVertexBuffer: data_buffer_frame[index_data_buffer_frame]
    offset: 0
    atIndex: metal_kit_vertex_input_index_frame_data
  ];

  [encoder_render
    setFragmentTexture: texture
    atIndex: 1
  ];

  [encoder_render
    setVertexBuffer: vertices_icosahedron
    offset: 0
    atIndex: metal_kit_vertex_input_index_positions
  ];

  for (
    unsigned int index_object = 0;
    index_object < length_objects_xyz;
    ++index_object
  ) {
    [encoder_render
      setVertexBytes: &index_object
      length: sizeof(uint32_t)
      atIndex: metal_kit_vertex_input_index_mesh_index
    ];

    [encoder_render
      drawIndexedPrimitives: MTLPrimitiveTypeTriangle
      indexCount: length_index_icosahedron
      indexType: MTLIndexTypeUInt32
      indexBuffer: indices_icosahedron
      indexBufferOffset: 0
    ];
  }
}

- (void) drawableSizeWillChange: (CGSize) size {
  float aspect = size.width / (float) size.height;
  float nearZ = 0.1f;
  float farZ = 100.0f;

  float ys = 1 / tanf(65.0f * (M_PI / 180.0f) * 0.5f);
  float xs = ys / aspect;
  float zs = farZ / (nearZ - farZ);

  matrix_projection = (matrix_float4x4) {{
    { xs, 0, 0, 0 },
    { 0,  ys, 0, 0 },
    { 0, 0, zs, -1 },
    { 0, 0, nearZ * zs, 0 }
  }};

  // matrix_projection[0][0] = xs;
  // matrix_projection[0][1] = 0.0f;
  // matrix_projection[0][2] = 0.0f;
  // matrix_projection[0][3] = 0.0f;

  // matrix_projection[1][0] = 0.0f;
  // matrix_projection[1][1] = ys;
  // matrix_projection[1][2] = 0.0f;
  // matrix_projection[1][3] = 0.0f;
  
  // matrix_projection[2][0] = 0.0f;
  // matrix_projection[2][1] = 0.0f;
  // matrix_projection[2][2] = zs;
  // matrix_projection[2][3] = -1.0f;

  // matrix_projection[3][0] = 0.0f;
  // matrix_projection[3][1] = 0.0f;
  // matrix_projection[3][2] = nearZ * zs;
  // matrix_projection[3][3] = 0.0f;
}

@end
