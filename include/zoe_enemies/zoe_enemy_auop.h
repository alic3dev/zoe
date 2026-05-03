#ifndef __zoe_zoe_enemies_zoe_enemy_auop_h
#define __zoe_zoe_enemies_zoe_enemy_auop_h

#include <zoe_enemies/zoe_enemy.h>

#include <metil.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_scenes/metil_scene.h>

#define zoe_enemy_auop_default_health_maximum 0x04
#define zoe_enemy_auop_default_health zoe_enemy_auop_default_health_maximum

void zoe_enemy_auop_initialize(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull,
  struct metil_renderable* _Nonnull
);

void zoe_enemy_auop_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_enemy* _Nonnull
);

#endif
