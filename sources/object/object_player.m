#include <object/object_player.h>

#include <mesh/mesh_player.h>
#include <mesh/mesh_player_mirror.h>
#include <zoe_pipeline_index.h>

#include <clic3_vector.h>

#include <metil_object/metil_object.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_camera/metil_camera.h>
#include <metil_scenes/metil_scene_controller.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_object_player_initialize(
  struct metil_object* metil_object,
  id<MTLTexture> texture,
  id<MTLDevice> metal_device,
  unsigned char mirror
) {
  if (
    mirror == 1
  ) {
    mesh_player_mirror_initialize(
      &metil_object->mesh
    );

    metil_object->poll = zoe_object_player_mirror_poll;
  } else {
    mesh_player_initialize(
      &metil_object->mesh
    );

    metil_object->positioning = metil_positioning_player;

    metil_object->poll = zoe_object_player_poll;
  }

  metil_object->index_pipeline_render = zoe_pipeline_index_player;

  metil_object_buffers_initialize(
    metil_object,
    metal_device
  );

  metil_object_texture_add(
    metil_object,
    texture
  );
}

void zoe_object_player_poll(
  struct metil* metil,
  struct metil_object* metil_object,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  metil_object->position.x = (
    ((struct metil_scene_controller*) metil->scene_controller)->scene.player.position.x
  );

  metil_object->position.y = (
    ((struct metil_scene_controller*) metil->scene_controller)->scene.player.position.y
  );

  metil_object->position.z = (
    ((struct metil_scene_controller*) metil->scene_controller)->scene.player.position.z
  );

  metil_object_poll(
    metil,
    metil_object,
    matrix_projection_static,
    matrix_object_projection,
    matrix_player_projection,
    metil_camera
  );
}

void zoe_object_player_mirror_poll(
  struct metil* metil,
  struct metil_object* metil_object,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  metil_object->position.x = (
    -metil_scene_controller->scene.player.position.x
  );

  metil_object->position.y = (
    metil_scene_controller->scene.player.position.y
  );

  metil_object->position.z = (
    -metil_scene_controller->scene.player.position.z
  );

  metil_object_poll(
    metil,
    metil_object,
    matrix_projection_static,
    matrix_object_projection,
    matrix_player_projection,
    metil_camera
  );
}
