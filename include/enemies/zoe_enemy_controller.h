#ifndef __zoe_enemies_zoe_enemy_controller_h
#define __zoe_enemies_zoe_enemy_controller_h

#include <damage/zoe_damage.h>
#include <enemies/zoe_enemy.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_scenes/metil_scene.h>

struct zoe_enemy_controller {
  struct metil_group* _Nonnull group_enemies;
  struct zoe_enemy* _Nonnull * _Nonnull enemies;
  unsigned int* _Nonnull length_enemies;

  unsigned int count_enemies_killed;
};

void zoe_enemy_controller_initialize(
  struct metil* _Nonnull,
  struct zoe_enemy_controller* _Nonnull,
  struct metil_group* _Nonnull
);

void zoe_enemy_controller_enemy_add(
  struct metil* _Nonnull,
  struct zoe_enemy_controller* _Nonnull
);

void zoe_enemy_controller_enemy_remove_at_index(
  struct metil* _Nonnull,
  struct zoe_enemy_controller* _Nonnull,
  unsigned int
);

void zoe_enemy_controller_enemies_add_length(
  struct metil* _Nonnull,
  struct zoe_enemy_controller* _Nonnull,
  unsigned int
);

void zoe_enemy_controller_damage_at_index(
  struct metil* _Nonnull,
  struct zoe_enemy_controller* _Nonnull,
  struct zoe_damage* _Nonnull,
  unsigned int
);

void zoe_enemy_controller_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_enemy_controller* _Nonnull
);

void zoe_enemy_controller_destroy(
  struct metil* _Nonnull,
  struct zoe_enemy_controller* _Nonnull
);

#endif
