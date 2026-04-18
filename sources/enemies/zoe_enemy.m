#include <enemies/zoe_enemy.h>

#include <clic3_memory.h>

#include <metil.h>
#include <metil_rendering/metil_renderable.h>

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

  zoe_enemy->destroy = (
    zoe_enemy_default_destroy
  );

  zoe_enemy->data = (
    0x00
  );
}

void zoe_enemy_poll(
  struct metil* metil,
  struct zoe_enemy* zoe_enemy
) {
  zoe_enemy->poll(
    metil,
    zoe_enemy
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
  struct zoe_enemy* zoe_enemy
) {
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
