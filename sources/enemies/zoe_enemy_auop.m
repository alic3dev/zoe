#include <enemies/zoe_enemy_auop.h>

#include <enemies/zoe_enemy.h>

#include <math_c_vector.h>

#include <metil_mesh/metil_mesh_box.h>
#include <metil_object/metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>

void zoe_enemy_auop_initialize(
  struct metil* metil,
  struct zoe_enemy* zoe_enemy_auop,
  struct metil_renderable* zoe_enemy_auop_renderable
) {
  zoe_enemy_initialize(
    metil,
    zoe_enemy_auop,
    zoe_enemy_auop_renderable
  );

  zoe_enemy_auop->health_maximum = (
    zoe_enemy_auop_default_health_maximum
  );

  zoe_enemy_auop->health = (
    zoe_enemy_auop_default_health
  );

  metil_renderable_initialize(
    zoe_enemy_auop->renderable,
    metil_renderable_type_object
  );

  struct metil_object* zoe_enemy_object = (
    zoe_enemy_auop->renderable->renderable
  );

  metil_mesh_box_initialize(
    &zoe_enemy_object->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0x04
      ),
      .y = (
        0x08
      ),
      .z = (
        0x04
      )
    }
  );

  metil_object_buffers_initialize(
    zoe_enemy_object,
    metil->renderer_interface.metal_device
  );

  zoe_enemy_auop->position = &(
    zoe_enemy_object->position
  );

  zoe_enemy_auop->rotation = &(
    zoe_enemy_object->rotation
  );

  zoe_enemy_auop->size = &(
    zoe_enemy_object->mesh.size
  );

  zoe_enemy_auop->poll = (
    zoe_enemy_auop_poll
  );
}

void zoe_enemy_auop_poll(
  struct metil* metil,
  struct metil_scene* metil_scene,
  struct zoe_enemy* zoe_enemy_auop
) {
  float amount = (
    (float)
    metil_scene->time_delta *
    0.01f
  );

  zoe_enemy_auop->position->x = (
    zoe_enemy_auop->position->x +
    (float)
    (
      (
        zoe_enemy_auop->position->x >
        metil_scene->player.position.x
      )
      ? -0x01
      :  0x01
    ) *
    amount
  );

  zoe_enemy_auop->position->z = (
    zoe_enemy_auop->position->z +
    (float)
    (
      (
        zoe_enemy_auop->position->z >
        metil_scene->player.position.z
      )
      ? -0x01
      :  0x01
    ) *
    amount
  );
}
