#include <model/model_player.h>

#include <mesh/mesh_player.h>
#include <mesh/mesh_player_head.h>
#include <mesh/mesh_player_mirror.h>
#include <zoe_pipeline_index.h>

#include <math_c_vector.h>

#include <metil.h>
#include <metil_model/metil_model.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_camera/metil_camera.h>
#include <metil_scenes/metil_scene_controller.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_model_player_initialize(
  struct metil* metil,
  struct metil_model* metil_model,
  id<MTLTexture> texture,
  unsigned char mirror
) {
  metil_model_objects_add_length(
    metil_model,
    1
  );

  struct metil_object* metil_object_body = &(
    metil_model->objects[
      zoe_model_player_object_index_body
    ]
  );

  // struct metil_object* metil_object_head = &(
  //   metil_model->objects[
  //     zoe_model_player_object_index_head
  //   ]
  // );

  if (
    mirror == 1
  ) {
    mesh_player_mirror_initialize(
      &metil_object_body->mesh
    );

    metil_model->poll = (
      zoe_model_player_mirror_poll
    );
  } else {
    mesh_player_initialize(
      &metil_object_body->mesh
    );

    metil_model->positioning = (
      metil_positioning_player
    );

    metil_model->poll = (
      zoe_model_player_poll
    );
  }

  // mesh_player_head_initialize(
  //   &metil_object_head->mesh
  // );

  // metil_object_head->position.y = (
  //   metil_object_body->mesh.size.y +
  //   metil_object_head->mesh.size.y / 2.0f
  // );

  metil_object_body->index_pipeline_render = (
    zoe_pipeline_index_player
  );

  // metil_object_head->index_pipeline_render = (
  //   zoe_pipeline_index_player
  // );

  metil_model_vertex_joint_maps_initialize(
    metil_model
  );

  metil_model_buffers_initialize(
    metil,
    metil_model,
    metil->renderer_interface.metal_device
  );

  metil_model_texture_add(
    metil_model,
    texture
  );
}

void zoe_model_player_poll(
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

  metil_model->position.x = (
    scene_controller->scene.player.position.x
  );

  metil_model->position.y = (
    scene_controller->scene.player.position.y
  );

  metil_model->position.z = (
    scene_controller->scene.player.position.z
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

void zoe_model_player_mirror_poll(
  struct metil* metil,
  struct metil_model* metil_model,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  metil_model->position.x = (
    -metil_scene_controller->scene.player.position.x
  );

  metil_model->position.y = (
    metil_scene_controller->scene.player.position.y
  );

  metil_model->position.z = (
    -metil_scene_controller->scene.player.position.z
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
