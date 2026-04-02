#include <model/model_player.h>

#include <mesh/mesh_zoe_body.h>
#include <zoe_pipeline_index.h>

#include <math_c_absolute.h>
#include <math_c_minimum.h>
#include <math_c_vector.h>

#include <metil.h>
#include <metil_model/metil_model.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_camera/metil_camera.h>
#include <metil_scenes/metil_scene_controller.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_model_zoe_initialize(
  struct metil* metil,
  struct metil_model* metil_model
) {
  metil_model_objects_add_length(
    metil_model,
    1
  );

  struct metil_object* metil_object_zoe_body = &(
    metil_model->objects[
      0
    ]
  );

  mesh_zoe_body_initialize(
    &metil_object_zoe_body->mesh
  );

  metil_object_zoe_body->type_primitive = (
    MTLPrimitiveTypeTriangleStrip
  );

  metil_object_zoe_body->index_pipeline_render = (
    zoe_pipeline_index_zoe_body
  );

  metil_model_vertex_joint_maps_initialize(
    metil_model
  );

  metil_model_buffers_initialize(
    metil,
    metil_model,
    metil->renderer_interface.metal_device
  );
}

void zoe_model_zoe_poll(
  struct metil* metil,
  struct metil_model* metil_model,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct metil_scene_controller* scene_controller = (
    metil->scene_controller
  );

  metil_model_poll(
    metil,
    metil_model,
    matrix_projection_static,
    matrix_object_projection,
    matrix_player_projection,
    metil_camera
  );
}
