#include <rendering/zoe_renderer.h>

#include <input/map.h>
#include <input/keycodes.h>
#include <mesh/mesh.h>
#include <mesh/ground/mesh_ground.h>
#include <mesh/tree/mesh_tree.h>
#include <metal_kit_shader_types.h>
#include <object.h>
#include <paths.h>
#include <rendering/camera/camera.h>
#include <scenes/scene.h>
#include <termination.h>

#include <clic3.h>

#include <stdlib.h>

#include <GameController/GameController.h>
#include <MetalKit/MetalKit.h>
#include <simd/simd.h>

@implementation zoe_renderer

- (nonnull instancetype) initWithMetalKitView: (nonnull MTKView*) metal_kit_view {
  self = [super init];

  if (!self) {
    return self;
  }

  rendering_properties_initialize(
    &self->rendering_properties
  );

  self->iterator_id = 0;
  self->length_objects = total_length_objects;

  scene_initialize(
    &self->scene
  );

  metal_kit_device = metal_kit_view.device;

  metal_kit_view.depthStencilPixelFormat = MTLPixelFormatDepth32Float_Stencil8;
  metal_kit_view.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
  metal_kit_view.sampleCount = 1;

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
    index_buffer < count_max_frames;
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
      newBufferWithLength: self->length_objects * sizeof(uint64_t)
      options: MTLResourceStorageModeShared
    ];
  }

  MTKTextureLoader* texture_loader = [[MTKTextureLoader alloc] initWithDevice: metal_kit_device];

  texture_ground = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"0028.png"
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

  texture_tree = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"zoef.png"
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

  mesh_ground_initialize(
    &object_ground.mesh,
    2000.0f,
    500.0f,
    2000.0f
  );

  object_ground.vertices = [metal_kit_device
    newBufferWithBytes: object_ground.mesh.vertices
    length: object_ground.mesh.length_vertices * sizeof(struct clic3_vector4_float)
    options: MTLResourceStorageModeShared
  ];

  object_ground.indices = [metal_kit_device
    newBufferWithBytes: object_ground.mesh.indices
    length: object_ground.mesh.length_indices * sizeof(unsigned int)
    options: MTLResourceStorageModeShared
  ];

  object_ground.data = [metal_kit_device
    newBufferWithLength: sizeof(metal_kit_data_frame_object)
    options: MTLResourceStorageModeShared
  ];

  object_ground.texture = texture_ground;

  metal_kit_data_frame_object* data = object_ground.data.contents;
  data->id = iterator_id++;
  data->mode_texture = mode_texture_ground;

  for (
    unsigned short int index_object = 0;
    index_object < self->length_objects;
    ++index_object
  ) {
    mesh_tree_initialize(
      &(self->objects[index_object].mesh),
      1.0f,
      250.0f
    );

    self->objects[index_object].position.x = (
      -(self->objects[index_object].mesh.size.x / 2.0f) + (
        (((float)(rand() % 10000) / 5000.0f) - 1.0f) * 0.7f *
        (self->objects[index_object].mesh.size.x - (object_ground.mesh.size.x / 2.0f))
      )
    );

    self->objects[index_object].position.z = (
      -(self->objects[index_object].mesh.size.z / 2.0f) + (
        (((float)(rand() % 10000) / 5000.0f) - 1.0f) * 0.7f *
        (object_ground.mesh.size.z - (object_ground.mesh.size.z / 2.0f))
      )
    );

    self->objects[index_object].vertices = [metal_kit_device
      newBufferWithBytes: self->objects[index_object].mesh.vertices
      length: self->objects[index_object].mesh.length_vertices * sizeof(struct clic3_vector4_float)
      options: MTLResourceStorageModeShared
    ];

    self->objects[index_object].indices = [metal_kit_device
      newBufferWithBytes: self->objects[index_object].mesh.indices
      length: self->objects[index_object].mesh.length_indices * sizeof(unsigned int)
      options: MTLResourceStorageModePrivate
    ];

    self->objects[index_object].data = [metal_kit_device
      newBufferWithLength: sizeof(metal_kit_data_frame_object)
      options: MTLResourceStorageModeShared
    ];

    data = self->objects[index_object].data.contents;
    
    data->id = iterator_id++;
    data->mode_texture = mode_texture_default;

    self->objects[index_object].texture = self->texture_tree;
  }

  termination_on_function_add(
    zoe_renderer_on_termination,
    self
  );

  return self;
}

- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view {
  scene_input_poll(
    &self->scene
  );
  
  scene_poll(
    &self->scene
  );

  self->rendering_properties.count_completed_frames = (
    self->rendering_properties.count_completed_frames - 1
  );

  if (
    self->rendering_properties.count_completed_frames <= 0
  ) {
    pthread_mutex_lock(
      &self->rendering_properties.mutex_frame
    );
  }

  index_data_buffer_frame = (index_data_buffer_frame + 1) % count_max_frames;

  id<MTLCommandBuffer> command_buffer = [command_queue commandBuffer];

  MTLRenderPassDescriptor* descriptor_render_pass = metal_kit_view.currentRenderPassDescriptor;
  descriptor_render_pass.colorAttachments[0].clearColor = MTLClearColorMake(
    0.0324f,
    0.0424f,
    0.0649f,
    1.0f
  );

  descriptor_render_pass.visibilityResultBuffer = buffer_visibility[index_buffer_visibility_write];

  encoder_render = [command_buffer renderCommandEncoderWithDescriptor: descriptor_render_pass];

  [encoder_render setRenderPipelineState: state_pipeline];
  [encoder_render setDepthStencilState: depth_state];

  [self poll];
  [self render];

  [encoder_render endEncoding];

  [command_buffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
    self->index_buffer_visibility_read = (
      self->index_buffer_visibility_read + 1
    ) % length_buffers_visibility;

    self->rendering_properties.count_completed_frames = (
      self->rendering_properties.count_completed_frames + 1
    );

    if (
      self->rendering_properties.count_completed_frames == 0 ||
      self->rendering_properties.count_completed_frames == 1
    ) {
      pthread_mutex_unlock(
        &self->rendering_properties.mutex_frame
      );
    }
  }];

  [command_buffer presentDrawable: metal_kit_view.currentDrawable];
  [command_buffer commit];
}

- (void) poll_object: (struct object*) object {
  metal_kit_data_frame_object* data = object->data.contents;

  struct clic3_vector3_float position = {
    .x = object->position.x + self->scene.player.position.x,
    .y = object->position.y + self->scene.player.position.y,
    .z = object->position.z + self->scene.player.position.z
  };

  data->position.x = object->position.x;
  data->position.y = object->position.y;
  data->position.z = object->position.z;

  data->view_model_matrix_projection = matrix_multiply(
    self->rendering_properties.camera.matrix_viewport_projection,
    (
      (matrix_float4x4) {{
        { 1, 0, 0, 0 },
        { 0, cos(self->scene.player.rotation.x), sin(self->scene.player.rotation.x), 0 },
        { 0, -sin(self->scene.player.rotation.x), cos(self->scene.player.rotation.x), 0 },
        {
          1,
          1,
          1,
          1
        }
      }}
    )
  );

  data->view_model_matrix_projection = matrix_multiply(
    data->view_model_matrix_projection,
    (
      (matrix_float4x4) {{
        { cos(self->scene.player.rotation.y), 0, -sin(self->scene.player.rotation.y), 0 },
        { 0, 1, 0, 0 },
        { sin(self->scene.player.rotation.y), 0, cos(self->scene.player.rotation.y), 0 },
        {
          1,
          1,
          1,
          1
        }
      }}
    )
  );

  data->view_model_matrix_projection = matrix_multiply(
    data->view_model_matrix_projection,
    (matrix_float4x4) {{
      { 1, 0, 0, 0 },
      { 0, 1, 0, 0 },
      { 0, 0, 1, 0 },
      {
        position.x,
        position.y,
        position.z,
        1
      }
    }}
  );

  data->width = object->mesh.size.x;
  data->height = object->mesh.size.y;
  data->depth = object->mesh.size.z;

  data->noise = rand();
}

- (void) poll {
  const unsigned int _frame = (
    self->rendering_properties.frame++
  );

  if (
    self->rendering_properties.frame + 1 >= UINT_MAX - 1
  ) {
    self->rendering_properties.frame = 0;
  }

  metal_kit_data_frame* data_frame = (data_buffer_frame[index_data_buffer_frame]).contents;
  data_frame->frame = _frame;

  data_frame->rotation_camera.x = self->scene.player.rotation.x;
  data_frame->rotation_camera.y = self->scene.player.rotation.y;
  data_frame->rotation_camera.z = self->scene.player.rotation.z;

  data_frame->position_player.x = self->scene.player.position.x;
  data_frame->position_player.y = self->scene.player.position.y;
  data_frame->position_player.z = self->scene.player.position.z;

  [self poll_object: &self->object_ground];

  for (
    unsigned short int index_object = 0;
    index_object < self->length_objects;
    ++index_object
  ) {
    [self poll_object: &self->objects[index_object]];
  }
}

- (void) render_object: (struct object*) object {
  [encoder_render
    setVertexBuffer: data_buffer_frame[index_data_buffer_frame]
    offset: 0
    atIndex: metal_kit_vertex_input_index_frame_data
  ];

  [encoder_render
    setFragmentTexture: object->texture
    atIndex: 0
  ];

  [encoder_render
    setFragmentTexture: texture_tree
    atIndex: 1
  ];

  [encoder_render
    setVertexBuffer: object->vertices
    offset: 0
    atIndex: metal_kit_vertex_input_index_positions
  ];
  
  [encoder_render
    setVertexBuffer: object->data
    offset: 0
    atIndex: metal_kit_vertex_input_index_data
  ];
  
  [encoder_render
    drawIndexedPrimitives: MTLPrimitiveTypeTriangle
    indexCount: object->mesh.length_indices
    indexType: MTLIndexTypeUInt32
    indexBuffer: object->indices
    indexBufferOffset: 0
  ];
}

- (void) render {
  [self render_object: &object_ground];

  for (
    unsigned short int index_object = 0;
    index_object < self->length_objects;
    ++index_object
  ) {
    [self render_object: &self->objects[index_object]];
  }
}

- (void) mtkView: (nonnull MTKView*) metal_kit_view drawableSizeWillChange: (CGSize) size {}

- (void) drawableSizeWillChange: (CGSize) size {
  camera_ratio_aspect_set(
    &self->rendering_properties.camera, (
      (float) size.width /
      (float) size.height
    )
  );
}

- (void) destroy {
  rendering_properties_destory(
    &self->rendering_properties
  );

  for (
    unsigned short int index_object = 0;
    index_object < self->length_objects;
    ++index_object
  ) {
    object_destroy(
      &self->objects[index_object]
    );
  }
}

@end

void zoe_renderer_on_termination(
  void* _Nonnull reference
) {
  zoe_renderer* renderer = (zoe_renderer*) reference;

  [renderer destroy];
}
