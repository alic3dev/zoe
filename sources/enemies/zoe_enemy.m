#include <enemies/zoe_enemy.h>

#include <damage/zoe_damage.h>

#include <clic3_memory.h>

#include <metil.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_scenes/metil_scene.h>

void zoe_enemy_initialize(
  struct metil* metil,
  struct zoe_enemy* zoe_enemy,
  struct metil_renderable* zoe_enemy_renderable
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

  zoe_enemy->poll = (
    zoe_enemy_default_poll
  );

  zoe_enemy->damage = (
    zoe_enemy_default_damage
  );

  zoe_enemy->destroy = (
    zoe_enemy_default_destroy
  );

  zoe_enemy->data = (
    0x00
  );
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

void zoe_enemy_damage(
  struct metil* metil,
  struct zoe_enemy* zoe_enemy,
  struct zoe_damage* zoe_damage
) {
  zoe_enemy->damage(
    metil,
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
}

void zoe_enemy_default_damage(
  struct metil* metil,
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
}

void zoe_enemy_default_destroy(
  struct metil* metil,
  struct zoe_enemy* zoe_enemy
) {
  if (
    zoe_enemy->renderable !=
    0x00
  ) {
    metil_renderable_destroy(
      metil,
      zoe_enemy->renderable
    );
  }

  clic3_memory_free(
    zoe_enemy->data
  );
}
