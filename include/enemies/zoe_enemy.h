#ifndef __zoe_enemies_zoe_enemy_h
#define __zoe_enemies_zoe_enemy_h

#include <damage/zoe_damage.h>

#include <math_c_vector.h>

#include <metil.h>
#include <metil_rendering/metil_renderable.h>

#define zoe_enemy_default_health_maximum 5
#define zoe_enemy_default_health zoe_enemy_default_health_maximum

struct zoe_enemy;

typedef void (*zoe_enemy_function_poll)(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull
);

typedef void (*zoe_enemy_function_damage)(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull,
  struct zoe_damage* _Nonnull
);

typedef void (*zoe_enemy_function_destroy)(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull
);

struct zoe_enemy {
  unsigned short int health;
  unsigned short int health_maximum;

  struct metil_renderable* _Nonnull renderable;

  struct math_c_vector3_float* _Nonnull position;
  struct math_c_vector3_float* _Nonnull rotation;

  zoe_enemy_function_poll _Nonnull poll;
  zoe_enemy_function_damage _Nonnull damage;
  zoe_enemy_function_destroy _Nonnull destroy;

  void* _Nullable data;
};

void zoe_enemy_initialize(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull,
  struct metil_renderable* _Nonnull
);

void zoe_enemy_poll(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull
);

void zoe_enemy_damage(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull,
  struct zoe_damage* _Nonnull
);

void zoe_enemy_destroy(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull
);

void zoe_enemy_default_poll(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull
);

void zoe_enemy_default_damage(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull,
  struct zoe_damage* _Nonnull
);

void zoe_enemy_default_destroy(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull
);

#endif
