#include <zoe_enemies/zoe_enemy.h>

#include <zoe_damage/zoe_damage.h>
#include <zoe_data/zoe_data_enemy.h>

#include <clic3_memory.h>

#include <metil.h>
#include <metil_object/metil_object.h>
#include <metil_object/metil_object_buffer.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_scenes/metil_scene.h>

void zoe_enemy_initialize(
  struct metil* metil,
  struct zoe_enemy* zoe_enemy,
  struct metil_renderable* zoe_enemy_renderable,
  struct zoe_attack_effects_controller* zoe_attack_effects_controller
) {
  zoe_enemy->health_maximum = (
    zoe_enemy_default_health_maximum
  );

  zoe_enemy->health = (
    zoe_enemy_default_health
  );

  zoe_enemy->renderable = (
    zoe_enemy_renderable
  );

  zoe_enemy->time_damaged = (
    0x00
  );

  zoe_enemy->time_attacked = (
    0x00
  );

  zoe_enemy->time_range = (
    0x00
  );

  zoe_enemy->rate_attack = (
    0xde
  );

  zoe_enemy->range = (
    0x0f
  );

  zoe_enemy->poll = (
    zoe_enemy_default_poll
  );

  zoe_enemy->poll_data = (
    zoe_enemy_function_poll_data_get(
      zoe_enemy->renderable->type
    )
  );

  zoe_enemy->damage = (
    zoe_enemy_default_damage
  );

  zoe_enemy->destroy = (
    zoe_enemy_default_destroy
  );

  zoe_enemy->attack_effects_controller = (
    zoe_attack_effects_controller
  );

  zoe_enemy->data = (
    0x00
  );
}

void zoe_enemy_initialize_with_buffer_data(
  struct metil* metil,
  struct zoe_enemy* zoe_enemy,
  struct metil_renderable* zoe_enemy_renderable,
  struct zoe_attack_effects_controller* zoe_attack_effects_controller
) {
  zoe_enemy_initialize(
    metil,
    zoe_enemy,
    zoe_enemy_renderable,
    zoe_attack_effects_controller
  );

  zoe_enemy_buffer_data_add(
    metil,
    zoe_enemy
  );
}

void zoe_enemy_buffer_data_add(
  struct metil* metil,
  struct zoe_enemy* zoe_enemy
) {
  struct metil_object_buffer* metil_object_buffer = (
    0x00
  );

  switch (
    zoe_enemy->renderable->type
  ) {
    case metil_renderable_type_object: {
      struct metil_object* zoe_object_enemy = (
        zoe_enemy->renderable->renderable
      );

      metil_object_buffers_add(
        zoe_object_enemy,
        metil->renderer_interface.metal_device,
        metil_object_buffer_type_vertex
      );

      metil_object_buffer = &(
        zoe_object_enemy->buffers_vertex[
          zoe_object_enemy->length_buffers_vertex -
          0x01
        ]
      );
      break;
    }
    default: {
      break;
    }
  }

  if (
    metil_object_buffer !=
    0x00
  ) {
    metil_object_buffer->buffer = [
      metil->renderer_interface.metal_device
      newBufferWithLength: (
        sizeof(
          struct zoe_data_enemy
        )
      )
      options: (
        MTLResourceStorageModeShared
      )
    ];

    struct zoe_data_enemy* zoe_data_enemy = (
      metil_object_buffer->buffer.contents
    );

    zoe_data_enemy_initialize(
      zoe_data_enemy
    );
  }
}

zoe_enemy_function_poll_data zoe_enemy_function_poll_data_get(
  enum metil_renderable_type metil_renderable_type
) {
  switch (
    metil_renderable_type
  ) {
    case metil_renderable_type_object: {
      return (
        zoe_enemy_default_poll_data_object
      );
    }
    default: {
      return (
        zoe_enemy_default_poll_data_null
      );
    }
  }
}

void zoe_enemy_poll(
  struct metil* metil,
  struct metil_scene* metil_scene,
  struct zoe_enemy* zoe_enemy
) {
  zoe_enemy->poll(
    metil,
    metil_scene,
    zoe_enemy
  );
}

void zoe_enemy_data_poll(
  struct metil* metil,
  struct metil_scene* metil_scene,
  struct zoe_enemy* zoe_enemy
) {
  zoe_enemy->poll_data(
    metil,
    metil_scene,
    zoe_enemy
  );
}

void zoe_enemy_damage(
  struct metil* metil,
  struct metil_scene* metil_scene,
  struct zoe_enemy* zoe_enemy,
  struct zoe_damage* zoe_damage
) {
  zoe_enemy->damage(
    metil,
    metil_scene,
    zoe_enemy,
    zoe_damage
  );
}

void zoe_enemy_destroy(
  struct metil* metil,
  struct zoe_enemy* zoe_enemy
) {
  zoe_enemy->destroy(
    metil,
    zoe_enemy
  );
}

void zoe_enemy_default_poll(
  struct metil* metil,
  struct metil_scene* metil_scene,
  struct zoe_enemy* zoe_enemy
) {
  zoe_enemy->poll_data(
    metil,
    metil_scene,
    zoe_enemy
  );
}

void zoe_enemy_default_poll_data_object(
  struct metil* metil,
  struct metil_scene* metil_scene,
  struct zoe_enemy* zoe_enemy
) {
  struct metil_object* zoe_object_enemy = (
    zoe_enemy->renderable->renderable
  );

  struct zoe_data_enemy* zoe_data_enemy = (
    zoe_object_enemy->buffers_vertex[
      zoe_data_enemy_buffer_index_default_object -
      0x01
    ].buffer.contents
  );

  zoe_enemy_default_poll_data_enemy(
    metil,
    metil_scene,
    zoe_enemy,
    zoe_data_enemy
  );
}

void zoe_enemy_default_poll_data_null(
  struct metil* metil,
  struct metil_scene* metil_scene,
  struct zoe_enemy* zoe_enemy
) {
}

void zoe_enemy_default_poll_data_enemy(
  struct metil* metil,
  struct metil_scene* metil_scene,
  struct zoe_enemy* zoe_enemy,
  struct zoe_data_enemy* zoe_data_enemy
) {
  zoe_data_enemy->health = (
    zoe_enemy->health
  );

  zoe_data_enemy->health_maximum = (
    zoe_enemy->health_maximum
  );

  zoe_data_enemy->time_damaged = (
    zoe_enemy->time_damaged
  );
}

void zoe_enemy_default_damage(
  struct metil* metil,
  struct metil_scene* metil_scene,
  struct zoe_enemy* zoe_enemy,
  struct zoe_damage* zoe_damage
) {
  unsigned int damage_total = (
    zoe_damage->amount_primary +
    zoe_damage->amount_secondary
  );

  if (
    (
      zoe_enemy->health -
      damage_total
    ) <
    0x00
  ) {
    zoe_enemy->health = (
      0x00
    );
  } else {
    zoe_enemy->health = (
      zoe_enemy->health -
      damage_total
    );
  }

  zoe_enemy->time_damaged = (
    metil_scene->time_elapsed
  );
}

void zoe_enemy_default_destroy(
  struct metil* metil,
  struct zoe_enemy* zoe_enemy
) {
  clic3_memory_free(
    zoe_enemy->data
  );
}
