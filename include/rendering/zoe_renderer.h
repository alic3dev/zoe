#ifndef __zoe_renderer_h
#define __zoe_renderer_h

#include <mesh/mesh.h>
#include <metal_kit_shader_types.h>
#include <scenes/scene.h>

#include <MetalKit/MetalKit.h>


static const unsigned int max_buffers_in_flight = 3;
static const unsigned int length_buffers_visibility = max_buffers_in_flight + 1;

struct object {
  struct mesh mesh;
  _Nonnull id<MTLBuffer> data;
  _Nonnull id<MTLBuffer> indices;
  _Nonnull id<MTLBuffer> vertices;
  _Nonnull id<MTLTexture> texture;
  struct clic3_vector3_float position;
};

@interface zoe_renderer : NSObject<MTKViewDelegate> {
  dispatch_semaphore_t semaphore_in_flight;

  struct scene scene;
  struct object objects[total_length_objects];
  struct object object_ground;

  unsigned short int iterator_id;

  unsigned short int length_objects;
  
  id<MTLBuffer> buffer_visibility[length_buffers_visibility];
  id<MTLBuffer> data_buffer_frame[max_buffers_in_flight];
  id<MTLBuffer> index_buffer_mesh_current;

  id<MTLCommandQueue> command_queue;

  id<MTLDevice> metal_kit_device;

  id<MTLDepthStencilState> depth_state;
  id<MTLDepthStencilState> depth_state_writes_disable;

  id<MTLRenderCommandEncoder> encoder_render;

  id<MTLRenderPipelineState> state_pipeline;
  id<MTLRenderPipelineState> state_pipeline_no_render;

  id<MTLTexture> texture_ground;
  id<MTLTexture> texture_tree;

  matrix_float4x4 matrix_projection;

  struct clic3_vector3_unsigned_int size_viewport;

  unsigned char index_data_buffer_frame;
  uint64_t* buffer_result_visibility_from_read;
  
  unsigned int frame;
  unsigned int index_buffer_visibility_read;
  unsigned int index_buffer_visibility_write;
}

- (nonnull instancetype) initWithMetalKitView: (nonnull MTKView*) metal_kit_view;
- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view;

- (void) mtkView: (nonnull MTKView*) metal_kit_view drawableSizeWillChange: (CGSize) size;
- (void) drawableSizeWillChange: (CGSize) size;

- (void) poll;
- (void) poll_object: (nonnull struct object*) object;

- (void) render;
- (void) render_object: (nonnull struct object*) object;

- (void) destroy;

@end

void zoe_renderer_on_termination(void* _Nonnull);

#endif
