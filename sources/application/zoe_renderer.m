#include <application/zoe_renderer.h>

#include <input/map.h>
#include <input/keycodes.h>
#include <mesh/mesh.h>
#include <mesh/ground/mesh_ground.h>
#include <metal_kit_shader_types.h>
#include <paths.h>
#include <termination.h>

#include <clic3.h>

#include <stdlib.h>

#include <GameController/GameController.h>
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

  struct mesh mesh_ground;
  
  struct clic3_vector3_float position_user;
  struct clic3_vector3_float rotation_camera;

  struct clic3_vector3_unsigned_int size_viewport;

  float speed_input;

  unsigned char index_data_buffer_frame;
  uint64_t* buffer_result_visibility_from_read;
  
  unsigned int frame;
  unsigned int index_buffer_visibility_read;
  unsigned int index_buffer_visibility_write;
  unsigned int length_index_icosahedron;
  unsigned int length_index_ground;
  unsigned int length_total_vertices_ground;
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
  position_user.y = -11.0f;
  position_user.z = 0.0f;

  speed_input = 0.4f;

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

  mesh_ground_initialize(
    &mesh_ground,
    200.0f,
    10.0f,
    200.0f
  );

  length_index_ground = mesh_ground.length_indices;

  vertices_ground = [metal_kit_device
    newBufferWithBytes: mesh_ground.vertices
    length: mesh_ground.length_vertices * sizeof(struct clic3_vector4_float)
    options: MTLResourceStorageModeShared
  ];

  indices_ground = [metal_kit_device
    newBufferWithBytes: mesh_ground.indices
    length: mesh_ground.length_indices * sizeof(unsigned int)
    options: MTLResourceStorageModeShared
  ];

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

  MTKTextureLoader* texture_loader = [[MTKTextureLoader alloc] initWithDevice: metal_kit_device];

  texture = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"splat.png"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*)0
    error: (void*)0
  ];

  termination_on_function_add(
    zoe_renderer_on_termination,
    self
  );

  return self;
}

- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view {
  GCController* controller = [GCController current];
  // TODO: GCDualSenseGamepad: Add DualSense specific functionality
  GCExtendedGamepad* profile_controller = (
    controller != (void*)0
    ? (GCDualSenseGamepad*) [controller extendedGamepad]
    : (void*)0
  );

  if (profile_controller != (void*)0) {
    GCControllerButtonInput* trigger_left = [profile_controller leftTrigger];
    GCControllerButtonInput* trigger_right = [profile_controller rightTrigger];

    position_user.y = (
      position_user.y + (
        trigger_left.value + -trigger_right.value
      ) * speed_input
    );

    GCControllerDirectionPad* thumbstick_right = [profile_controller rightThumbstick];
    GCControllerAxisInput* input_axis_y_right = [thumbstick_right yAxis];
    GCControllerAxisInput* input_axis_x_right = [thumbstick_right xAxis];

    if (
      input_axis_x_right.value >= 0.1f || 
      input_axis_x_right.value <= -0.1f
    ) {
      rotation_camera.y = (
        rotation_camera.y + (
          input_axis_x_right.value *
          speed_input / 10.0f
        )
      );
    }

    if (
      input_axis_y_right.value >= 0.1f || 
      input_axis_y_right.value <= -0.1f
    ) {
      rotation_camera.z = (
        rotation_camera.z + (
          input_axis_y_right.value *
          speed_input / 10.0f
        )
      );
    }

    GCControllerDirectionPad* thumbstick_left = [profile_controller leftThumbstick];
    GCControllerAxisInput* input_axis_y_left = [thumbstick_left yAxis];
    GCControllerAxisInput* input_axis_x_left = [thumbstick_left xAxis];

    float ratio_axis = fmod(
      rotation_camera.y,
      (M_PI * 2.0f)
    ) / (M_PI * 2.0f);

    float ratio_z = 0.0f;
    float ratio_x = 0.0f;

    // ...there's a better way to do this,
    // I've done this before.
    // Over and over
    //
    // Though, ignorance is bliss
    // Of that I'm sure
    // Over and over 

    if (ratio_axis >= 0.0f) {
      if (
        ratio_axis <= 0.25f
      ) {
        ratio_z = (0.25f - ratio_axis) / 0.25f;
        ratio_x = -(ratio_axis / 0.25f);
      } else if (
        ratio_axis >= 0.25f &&
        ratio_axis <= 0.5f 
      ) {
        ratio_axis = ratio_axis - 0.25f;

        ratio_z = -(ratio_axis / 0.25f);
        ratio_x = -(0.25f - ratio_axis) / 0.25f;
      } else if (
        ratio_axis >= 0.5f &&
        ratio_axis <= 0.75f 
      ) {
        ratio_axis = ratio_axis - 0.5f;

        ratio_z = -(0.25f - ratio_axis) / 0.25f;
        ratio_x = (ratio_axis / 0.25f);
      } else {
        ratio_axis = ratio_axis - 0.75f;

        ratio_z = (ratio_axis / 0.25f);
        ratio_x = (0.25f - ratio_axis) / 0.25f;
      }
    } else {
      if (
        ratio_axis >= -0.25f
      ) {
        ratio_z = (-0.25f - ratio_axis) / -0.25f;
        ratio_x = -(ratio_axis / 0.25f);
      } else if (
        ratio_axis <= -0.25f &&
        ratio_axis >= -0.5f
      ) {
        ratio_axis = ratio_axis + 0.25f;

        ratio_z = -(ratio_axis / -0.25f);
        ratio_x = -(-0.25f - ratio_axis) / 0.25f;
      } else if (
        ratio_axis <= -0.5f &&
        ratio_axis >= -0.75f 
      ) {
        ratio_axis = ratio_axis + 0.5f;

        ratio_z = -(-0.25f - ratio_axis) / -0.25f;
        ratio_x = (ratio_axis / 0.25f);
      } else {
        ratio_axis = ratio_axis + 0.75f;

        ratio_z = (ratio_axis / -0.25f);
        ratio_x = (-0.25f - ratio_axis) / 0.25f;
      }
    }

    position_user.z = (
      position_user.z + (
        input_axis_y_left.value *
        speed_input *
        ratio_z
      ) 
    );

    position_user.x = (
      position_user.x + (
        input_axis_y_left.value *
        speed_input *
        ratio_x
      )
    );

    ratio_axis = fmod(
      rotation_camera.y,
      (M_PI * 2.0f)
    ) / (M_PI * 2.0f);

    if (ratio_axis >= 0.0f) {
      if (
        ratio_axis <= 0.25f
      ) {
        ratio_z = -(ratio_axis / 0.25f);
        ratio_x = -(0.25f - ratio_axis) / 0.25f;
      } else if (
        ratio_axis >= 0.25f &&
        ratio_axis <= 0.5f 
      ) {
        ratio_axis = ratio_axis - 0.25f;

        ratio_z = -(0.25f - ratio_axis) / 0.25f;
        ratio_x = (ratio_axis / 0.25f);
      } else if (
        ratio_axis >= 0.5f &&
        ratio_axis <= 0.75f 
      ) {
        ratio_axis = ratio_axis - 0.5f;

        ratio_z = (ratio_axis / 0.25f);
        ratio_x = (0.25f - ratio_axis) / 0.25f;
      } else {
        ratio_axis = ratio_axis - 0.75f;

        ratio_z = (0.25f - ratio_axis) / 0.25f;
        ratio_x = -(ratio_axis / 0.25f);
      }
    } else {
      if (
        ratio_axis >= -0.25f
      ) {
        ratio_z = -(ratio_axis / 0.25f);
        ratio_x = -(-0.25f - ratio_axis) / -0.25f;
      } else if (
        ratio_axis <= -0.25f &&
        ratio_axis >= -0.5f 
      ) {
        ratio_axis = ratio_axis + 0.25f;

        ratio_z = -(-0.25f - ratio_axis) / 0.25f;
        ratio_x = (ratio_axis / -0.25f);
      } else if (
        ratio_axis <= -0.5f &&
        ratio_axis >= -0.75f 
      ) {
        ratio_axis = ratio_axis + 0.5f;

        ratio_z = (ratio_axis / 0.25f);
        ratio_x = (-0.25f - ratio_axis) / -0.25f;
      } else {
        ratio_axis = ratio_axis + 0.75f;

        ratio_z = (-0.25f - ratio_axis) / 0.25f;
        ratio_x = -(ratio_axis / -0.25f);
      }
    }

    position_user.z = (
      position_user.z + (
        input_axis_x_left.value *
        speed_input *
        ratio_z
      )
    );

    position_user.x = (
      position_user.x + (
        input_axis_x_left.value *
        speed_input *
        ratio_x
      )
    );
  }

  if (
    input_map_keydown[
      keycode_up_arrow
    ] == 1
  ) {
    if (
      input_map_keydown[
        keycode_shift_left
      ] == 1 ||
      input_map_keydown[
        keycode_shift_right
      ] == 1
    ) {
      position_user.z += speed_input;
    } else {
      position_user.y -= speed_input;
    }
  }

  if (
    input_map_keydown[
      keycode_down_arrow
    ] == 1
  ) {
    if (
      input_map_keydown[
        keycode_shift_left
      ] == 1 ||
      input_map_keydown[
        keycode_shift_right
      ] == 1
    ) {
      position_user.z -= speed_input;
    } else {
      position_user.y += speed_input;
    }
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

  if (
    input_map_keydown[
      keycode_z
    ] == 1
  ) {
    speed_input = (
      speed_input - 0.125f
    );

    input_map_keydown[
      keycode_z
    ] = 0;
  }

  if (
    input_map_keydown[
      keycode_x
    ] == 1
  ) {
    speed_input = (
      speed_input + 0.125
    );

    input_map_keydown[
      keycode_x
    ] = 0;
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

  if (frame + 1 >= UINT_MAX - 1) {
    frame = 0;
  }

  const struct clic3_vector3_float center_grid = {
    .x = (float)(length_objects_x - 1) / 2.0f,
    .y = (float)(length_objects_y - 1) / 2.0f,
    .z = (float)(length_objects_z - 1) * 2.0f
  };

  const struct clic3_vector3_float scale_grid = {
    .x = 1.0f,
    .y = 1.0f,
    .z = 1.0f
  };

  metal_kit_data_frame* data_frame = (data_buffer_frame[index_data_buffer_frame]).contents;
  data_frame->frame = _frame;

  unsigned int index_object = 0;

  data_frame->objects[length_objects_xyz - 1].view_model_matrix_projection = matrix_multiply(
    matrix_projection,
    // matrix_multiply(
    (
      (matrix_float4x4) {{
        { cos(rotation_camera.y), 0, -sin(rotation_camera.y), 0 },
        { 0, 1, 0, 0 },
        { sin(rotation_camera.y), 0, cos(rotation_camera.y), 0 },
        {
          1,
          1,
          1,
          1
        }
      }}
      // (matrix_float4x4) {{
      //   { cos(rotation_camera.z), sin(rotation_camera.z), 0, 0 },
      //   { -sin(rotation_camera.z), cos(rotation_camera.z), 0, 0 },
      //   { 0, 0, 1, 0 },
      //   {
      //     1,
      //     1,
      //     1,
      //     1
      //   }
      // }}
    )
  );

  data_frame->objects[length_objects_xyz - 1].view_model_matrix_projection = matrix_multiply(
    data_frame->objects[length_objects_xyz - 1].view_model_matrix_projection,
    (matrix_float4x4) {{
      { 1, 0, 0, 0 },
      { 0, 1, 0, 0 },
      { 0, 0, 1, 0 },
      {
        ((length_objects_x / 2) + position_user.x - center_grid.x) * scale_grid.x,
        (position_user.y - center_grid.y) * scale_grid.y,
        ((length_objects_z / 2) + position_user.z - center_grid.z) * scale_grid.z,
        1
      }
    }}
  );

  data_frame->rotation_camera.x = rotation_camera.x;
  data_frame->rotation_camera.y = rotation_camera.y;
  data_frame->rotation_camera.z = rotation_camera.z;

  data_frame->objects[length_objects_xyz - 1].width = mesh_ground.size.x;
  data_frame->objects[length_objects_xyz - 1].height = mesh_ground.size.y;
  data_frame->objects[length_objects_xyz - 1].depth = mesh_ground.size.z;

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
          // matrix_multiply(
          (
            (matrix_float4x4) {{
              { cos(rotation_camera.y), 0, -sin(rotation_camera.y), 0 },
              { 0, 1, 0, 0 },
              { sin(rotation_camera.y), 0, cos(rotation_camera.y), 0 },
              {
                1,
                1,
                1,
                1
              }
            }}
            // (matrix_float4x4) {{
            //   { cos(rotation_camera.z), sin(rotation_camera.z), 0, 0 },
            //   { -sin(rotation_camera.z), cos(rotation_camera.z), 0, 0 },
            //   { 0, 0, 1, 0 },
            //   {
            //     1,
            //     1,
            //     1,
            //     1
            //   }
            // }}
          )
        );

        data_frame->objects[index_object].view_model_matrix_projection = matrix_multiply(
          data_frame->objects[index_object].view_model_matrix_projection,
          matrix_model_view
        );

        data_frame->objects[index_object].width = 1.0f;
        data_frame->objects[index_object].height = 1.0f;
        data_frame->objects[index_object].depth = 1.0f;

        data_frame->objects[index_object].noise = rand();

        ++index_object;
      }
    }
  }
}

- (void) renderMainRenderPass {
  unsigned int index_object = length_objects_xyz - 1;

  [encoder_render
    setVertexBuffer: data_buffer_frame[index_data_buffer_frame]
    offset: 0
    atIndex: metal_kit_vertex_input_index_frame_data
  ];

  [encoder_render
    setFragmentTexture: texture
    atIndex: 0
  ];

  [encoder_render
    setVertexBuffer: vertices_ground
    offset: 0
    atIndex: metal_kit_vertex_input_index_positions
  ];

  [encoder_render
    setVertexBytes: &index_object
    length: sizeof(unsigned int)
    atIndex: metal_kit_vertex_input_index_mesh_index
  ];
  
  [encoder_render
    drawIndexedPrimitives: MTLPrimitiveTypeTriangle
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
    setVertexBuffer: vertices_icosahedron
    offset: 0
    atIndex: metal_kit_vertex_input_index_positions
  ];

  for (
    index_object = 0;
    index_object < length_objects_xyz - 1;
    ++index_object
  ) {
    [encoder_render
      setVertexBytes: &index_object
      length: sizeof(unsigned int)
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

  float ys = 1 / tanf(90.0f * (M_PI / 180.0f) * 0.5f);
  float xs = ys / aspect;
  float zs = farZ / (nearZ - farZ);

  matrix_projection = (matrix_float4x4) {{
    { xs, 0, 0, 0 },
    { 0,  ys, 0, 0 },
    { 0, 0, zs, -1 },
    { 0, 0, nearZ * zs, 0 }
  }};
}

- (void) destroy {
  mesh_destroy(&mesh_ground);
}

@end

void zoe_renderer_on_termination(
  void* _Nonnull reference
) {
  zoe_renderer* renderer = (zoe_renderer*) reference;

  [renderer destroy];
}
