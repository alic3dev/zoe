#import <zoe_renderer.h>
#include <input/map.h>
#include <input/keycodes.h>
#import <metal_kit_shader_types.h>

#include <MetalKit/MetalKit.h>
#include <simd/simd.h>

static const unsigned int max_buffers_in_flight = 3;

static const unsigned int length_buffers_visibility = max_buffers_in_flight + 1;

@implementation zoe_renderer {
  uint64_t* buffer_result_visibility_from_read;
  id<MTLBuffer> buffer_visibility[length_buffers_visibility];
  id<MTLCommandQueue> command_queue;
  id<MTLBuffer> data_buffer_frame[max_buffers_in_flight];
  id<MTLDepthStencilState> depth_state;
  id<MTLDepthStencilState> depth_state_writes_disable;
  id<MTLRenderCommandEncoder> encoder_render;
  id<MTLBuffer> index_buffer_mesh_current;
  unsigned int index_buffer_visibility_read;
  unsigned int index_buffer_visibility_write;
  uint8_t index_data_buffer_frame;
  unsigned int index_index_mesh_current;
  id<MTLBuffer> indices_icosahedron;
  unsigned int length_index_icosahedron;
  matrix_float4x4 matrix_projection;
  MTLVertexDescriptor* metal_descriptor_vertex;
  id<MTLDevice> metal_kit_device;
  dispatch_semaphore_t semaphore_in_flight;
  vector_uint2 size_viewport;
  id<MTLRenderPipelineState> state_pipeline;
  id<MTLRenderPipelineState> state_pipeline_no_render;
  id<MTLBuffer> vertices_icosahedron;
  id<MTLTexture> texture;
  unsigned int frame;

  simd_float3 position_user;
  float speed_input;
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

  position_user = simd_make_float3(
    0,
    0,
    0
  );

  speed_input = 0.1f;

  id<MTLLibrary> library_default = [metal_kit_device newDefaultLibrary];
  id<MTLFunction> function_vertex = [library_default newFunctionWithName: @"shader_vertex"];
  id<MTLFunction> function_fragment = [library_default newFunctionWithName: @"shader_fragment"];

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

  const float radius_sphere = 0.7;
  const float animation_adjustment_factor = 4;
  const float radius = animation_adjustment_factor * radius_sphere;

  float segment = 0.3;

  vector_float4 icosahedronVertices[] = {
    { -segment, -segment, segment, 1.0 },
    { segment, -segment, segment, 1.0 },
    { -segment, -segment, -segment, 1.0 },
    { segment, -segment, -segment, 1.0 },
    { -segment, segment, segment, 1.0 },
    { segment, segment, segment, 1.0 },
    { -segment, segment, -segment, 1.0 },
    { segment, segment, -segment, 1.0 },
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

  _position = 1.0;

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

  [encoder_render
    setVertexBuffer: data_buffer_frame[index_data_buffer_frame]
    offset: 0
    atIndex: metal_kit_vertex_input_index_frame_data
  ];

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

  const simd_float3 center_grid = simd_make_float3(
    (float)(length_objects_x - 1) / 2.0f,
    (float)(length_objects_y - 1) / 2.0f,
    0.0f
  );

  const simd_float3 scale_grid = simd_make_float3(2.0f, 2.0f, -2.0f);
  const simd_float3 center_camera = simd_make_float3(_position, 0.0f, -3.0f - (float) length_objects_x);

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
        simd_float3 position = (
          center_camera + scale_grid * (
            simd_make_float3(
              index_x + position_user.x,
              index_y + position_user.y,
              index_z + position_user.z
            ) - center_grid
          )
        );

        matrix_float4x4 matrix_model_view = (matrix_float4x4) {{
          { 1, 0, 0, 0 },
          { 0, 1, 0, 0 },
          { 0, 0, 1, 0 },
          { position.x, position.y, position.z, 1 }
        }};

        data_frame->objects[index_object].view_model_matrix = matrix_model_view;
        data_frame->objects[index_object].view_model_matrix_projection = matrix_multiply(
          matrix_projection,
          matrix_model_view
        );

        data_frame->objects[index_object].color = simd_make_float3(
          ((float)index_x + 1.0f) / (float)length_objects_x,
          ((float)index_y + 1.0f) / (float)length_objects_y,
          ((float)index_z + 1.0f) / (float)length_objects_z
        );

        ++index_object;
      }
    }
  }
}

- (void) renderMainRenderPass {
  index_buffer_mesh_current = indices_icosahedron;
  index_index_mesh_current = length_index_icosahedron;

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
      indexCount: index_index_mesh_current
      indexType: MTLIndexTypeUInt32
      indexBuffer: index_buffer_mesh_current
      indexBufferOffset: 0
    ];
  }
}

- (void) drawableSizeWillChange: (CGSize) size {
  float aspect = size.width / (float) size.height;
  float nearZ = 0.1f;
  float farZ = 100.0f;

  float ys = 1 / tanf(65.0f * (M_PI / 180.0f) * 0.5);
  float xs = ys / aspect;
  float zs = farZ / (nearZ - farZ);

  matrix_projection = (matrix_float4x4) {{
    { xs, 0, 0, 0 },
    { 0,  ys, 0, 0 },
    { 0, 0, zs, -1 },
    { 0, 0, nearZ * zs, 0 }
  }};
}

@end
