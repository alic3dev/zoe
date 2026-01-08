#include <object/object_text_backing.h>

#include <zoe_pipeline_index.h>

#include <metil_mesh/metil_mesh_2d/metil_mesh_rectangle.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <math_c_vector.h>

#include <Metal/MTLDevice.h>

void object_text_backing_initialize(
  struct metil_object* metil_object_text_backing,
  id<MTLDevice> metal_device,
  struct math_c_vector3_float* size,
  struct math_c_vector3_float* position
) {
  metil_mesh_rectangle_initialize(
    &metil_object_text_backing->mesh,
    (struct math_c_vector2_float) {
      .x = size->x * 1.1f,
      .y = size->y * 1.2f
    }
  );

  metil_object_text_backing->positioning = (
    metil_positioning_static
  );

  metil_object_text_backing->position.x = (
    position->x
  );

  metil_object_text_backing->position.y = (
    position->y
  );

  metil_object_text_backing->position.z = (
    position->z
  );

  metil_object_text_backing->index_pipeline_render = (
    zoe_pipeline_index_text_backing
  );

  metil_object_buffers_initialize(
    metil_object_text_backing,
    metal_device
  );

  struct metil_renderer_data_object* metil_renderer_data_object_text_backing = (
    metil_object_text_backing->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  metil_renderer_data_object_text_backing->color.x = 0.0f;
  metil_renderer_data_object_text_backing->color.y = 0.0f;
  metil_renderer_data_object_text_backing->color.z = 0.0f;
  metil_renderer_data_object_text_backing->color.w = 1.0f;
}
