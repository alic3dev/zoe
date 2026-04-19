#include <enemies/zoe_enemy_controller.h>

#include <clic3_memory.h>

#include <metil_group.h>

void zoe_enemy_controller_initialize(
  struct metil* metil,
  struct zoe_enemy_controller* zoe_enemy_controller,
  struct metil_group* group_enemies
) {
  zoe_enemy_controller->group_enemies = (
    group_enemies
  );

  zoe_enemy_controller->length_enemies = &(
    zoe_enemy_controller->group_enemies->length
  );

  zoe_enemy_controller->enemies = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_enemy
      ) *
      *zoe_enemy_controller->length_enemies
    )
  );

  zoe_enemy_controller->count_enemies_killed = (
    0x00
  );
}

void zoe_enemy_controller_enemy_add(
  struct metil* metil,
  struct zoe_enemy_controller* zoe_enemy_controller
) {
  static struct metil_renderable* metil_renderable_enemy;

  metil_renderable_enemy = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_renderable
      )
    )
  );

  metil_group_add(
    zoe_enemy_controller->group_enemies,
    metil_renderable_enemy
  );
}

void zoe_enemy_controller_enemy_remove_at_index(
  struct metil* metil,
  struct zoe_enemy_controller* zoe_enemy_controller,
  unsigned int index_enemy
) {
  metil_group_destroy_renderable_at_index(
    metil,
    zoe_enemy_controller->group_enemies,
    index_enemy
  );}

void zoe_enemy_controller_enemies_add_length(
  struct metil* metil,
  struct zoe_enemy_controller* zoe_enemy_controller,
  unsigned int length
) {
  metil_group_add_length_unallocated(
    zoe_enemy_controller->group_enemies,
    length
  );
}

void zoe_enemy_controller_damage_at_index(
  struct metil* metil,
  struct zoe_enemy_controller* zoe_enemy_controller,
  struct zoe_damage* zoe_damage,
  unsigned int index_enemy
) {
  struct zoe_enemy* zoe_enemy = &(
    zoe_enemy_controller->enemies[
      index_enemy
    ]
  );

  zoe_enemy->damage(
    metil,
    zoe_enemy,
    zoe_damage
  );

  if (
    zoe_enemy->health ==
    0x00
  ) {
    zoe_enemy_controller_enemy_remove_at_index(
      metil,
      zoe_enemy_controller,
      index_enemy
    );
  }}
