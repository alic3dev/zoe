#include <zoe_enemies/zoe_enemy_auop.h>

#include <zoe_data/data_zoe.h>
#include <zoe_enemies/zoe_enemy.h>
#include <zoe_object/zoe_object_auop.h>

#include <math_c_absolute.h>
#include <math_c_angles.h>
#include <math_c_modulus.h>
#include <math_c_pi.h>

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

  metil_renderable_initialize(
    zoe_enemy_auop_renderable,
    metil_renderable_type_object
  );

  struct metil_object* zoe_enemy_object_auop = (
    zoe_enemy_auop_renderable->renderable
  );

  zoe_object_auop_initialize(
    metil,
    zoe_enemy_object_auop
  );

  zoe_enemy_object_auop->index_pipeline_render = (
    zoe_data_zoe->pipeline_index.auop
  );

  zoe_enemy_initialize_with_buffer_data(
    metil,
    zoe_enemy_auop,
    zoe_enemy_auop_renderable
  );

  zoe_enemy_auop->health = (
    zoe_enemy_auop_default_health
  );

  zoe_enemy_auop->health_maximum = (
    zoe_enemy_auop_default_health_maximum
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

  float rotation_y = (
    math_c_angle_from_vector3_float_xz(
      zoe_enemy_auop->position,
      &metil_scene->player.position
    )
  );

  float distance_a = (
    zoe_enemy_auop->rotation->y -
    rotation_y
  );

  float distance_b = (
    zoe_enemy_auop->rotation->y -
    -rotation_y
  );

  if (
    math_c_absolute_float(
      distance_a
    ) <
    math_c_absolute_float(
      distance_b
    )
  ) {
    zoe_enemy_auop->rotation->y = (
      zoe_enemy_auop->rotation->y -
      distance_a *
      0.025f *
      (float)
      metil_scene->time_delta
    );
  } else {
    zoe_enemy_auop->rotation->y = (
      zoe_enemy_auop->rotation->y +
      distance_b *
      0.025f *
      (float)
      metil_scene->time_delta
    );
  }
  if (
    zoe_enemy_auop->rotation->y >=
    math_c_pi_doubled
  ) {
    zoe_enemy_auop->rotation->y = (
      zoe_enemy_auop->rotation->y -
      (float)
      (
        (unsigned int)
        (
          zoe_enemy_auop->rotation->y /
          math_c_pi_doubled
        )
      ) *
      math_c_pi_doubled
    );
  } else if (
    zoe_enemy_auop->rotation->y <=
    math_c_pi_doubled
  ) {
    zoe_enemy_auop->rotation->y = (
      zoe_enemy_auop->rotation->y +
      (float)
      (
        (unsigned int)
        (
          -zoe_enemy_auop->rotation->y /
          math_c_pi_doubled
        )
      ) *
      math_c_pi_doubled
    );
  }

  struct math_c_vector2_float ratio = {
    .y = (
      math_c_modulus_mirror_float(
        math_c_absolute_float(
          zoe_enemy_auop->rotation->y
        ),
        math_c_pi
      ) /
      math_c_pi
    )
  };

  if (
    ratio.y <=
    0.5f
  ) {
    ratio.y = (
      0x01 -
      ratio.y /
      0.5f
    );

    ratio.x = (
      0x01 -
      ratio.y
    );
  } else {
    ratio.y = -(
      (
        ratio.y -
        0.5f
       ) /
       0.5f
    );

    ratio.x = (
      0x01 -
      -ratio.y
    );
  }

  if (
    (
      (
        zoe_enemy_auop->rotation->y >
        math_c_pi
      ) &&
      (
        zoe_enemy_auop->rotation->y <
        math_c_pi_doubled
      )
    ) ||
    (
      (
        zoe_enemy_auop->rotation->y >
        -math_c_pi
      ) &&
      (
        zoe_enemy_auop->rotation->y <
        0x00
      )
    )
  ) {
    ratio.x = -(
      ratio.x
    );
  }

  zoe_enemy_auop->position->x = (
    zoe_enemy_auop->position->x -
    ratio.x *
    amount
  );

  zoe_enemy_auop->position->z = (
    zoe_enemy_auop->position->z -
    ratio.y *
    amount
  );

  zoe_enemy_data_poll(
    metil,
    metil_scene,
    zoe_enemy_auop
  );
}
