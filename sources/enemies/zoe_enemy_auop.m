#include <enemies/zoe_enemy_auop.h>

#include <data/data_zoe.h>
#include <enemies/zoe_enemy.h>
#include <object/zoe_object_auop.h>

#include <math_c_absolute.h>
#include <math_c_pi.h>
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
  struct zoe_data_zoe* zoe_data_zoe = (
    metil->data
  );

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

  struct metil_object* zoe_enemy_object_auop = (
    zoe_enemy_auop->renderable->renderable
  );

  zoe_object_auop_initialize(
    metil,
    zoe_enemy_object_auop
  );

  zoe_enemy_auop->position = &(
    zoe_enemy_object_auop->position
  );

  zoe_enemy_auop->rotation = &(
    zoe_enemy_object_auop->rotation
  );

  zoe_enemy_auop->size = &(
    zoe_enemy_object_auop->mesh.size
  );

  zoe_enemy_auop->poll = (
    zoe_enemy_auop_poll
  );

  zoe_enemy_object_auop->index_pipeline_render = (
    zoe_data_zoe->pipeline_index.auop
  );}

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

  struct math_c_vector2_float difference = {
    .x = (
      zoe_enemy_auop->position->x -
      metil_scene->player.position.x
    ),
    .y = (
      zoe_enemy_auop->position->z -
      metil_scene->player.position.z
    )
  };

  struct math_c_vector2_float absolutes = {
    .x = (
      math_c_absolute_float(
        difference.x
      )
    ),
    .y = (
      math_c_absolute_float(
        difference.y
      )
    )
  };


  float total = (
    absolutes.x +
    absolutes.y
  );

  struct math_c_vector2_float ratio = {
    .x = (
      difference.x /
      total
    ),
    .y = (
      difference.y /
      total
    )
  };

  float angle = (
    (
      0x01 -
      (
        ratio.y +
        0x01
      ) /
      0x02
    ) *
    math_c_pi *
    (
      ratio.x <
      0x00
      ? -1 : 1
    )
  );

  zoe_enemy_auop->rotation->y = (
    angle
  );
}
