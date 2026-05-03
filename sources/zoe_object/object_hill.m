#include <zoe_object/object_hill.h>

#include <zoe_mesh/mesh_hill.h>
#include <zoe_pipeline_index.h>

#include <math_c_vector.h>

#include <metil_object/metil_object.h>
#include <metil_scenes/metil_scene_controller.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_object_hill_initialize(
  struct metil_object* metil_object,
  id<MTLTexture> texture_one,
  id<MTLTexture> texture_two,
  id<MTLTexture> texture_lighting,
  struct zoe_pipeline_index* zoe_pipeline_index,
  id<MTLDevice> metal_device
) {
  mesh_hill_initialize(
    &metil_object->mesh
  );

  metil_object_buffers_initialize_with_data_size(
    metil_object,
    metal_device,
    sizeof(
      struct zoe_data_object_hill
    )
  );

  struct zoe_data_object_hill* zoe_data_object_hill = (
    metil_object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  zoe_data_object_hill->size.x = (
    metil_object->mesh.size.x
  );

  zoe_data_object_hill->size.y = (
    metil_object->mesh.size.y
  );

  zoe_data_object_hill->size.z = (
    metil_object->mesh.size.z
  );
  metil_object->poll = (
    zoe_object_hill_poll
  );

  metil_object->index_pipeline_render = (
    zoe_pipeline_index->hill
  );

  metil_object_texture_add(
    metil_object,
    texture_one
  );

  metil_object_texture_add(
    metil_object,
    texture_two
  );

  metil_object_texture_add(
    metil_object,
    texture_lighting
  );
}

void zoe_object_hill_poll(
  struct metil* metil,
  struct metil_object* metil_object,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct zoe_data_object_hill* data = (
    metil_object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  data->position.x = (
    metil_object->position.x
  );

  data->position.y = (
    metil_object->position.y
  );

  data->position.z = (
    metil_object->position.z
  );

  metil_positioning_view_model_matrix_projection_set(
    metil_object->positioning,
    &data->view_model_matrix_projection,
    matrix_projection_static,
    matrix_object_projection,
    matrix_player_projection,
    &metil_object->position,
    &metil_object->rotation,
    &(
      (struct metil_scene_controller*)
      metil->scene_controller
    )->scene.player.position,
    metil_camera
  );
}
