#ifndef __zoe_zoe_enemies_zoe_enemy_h
#define __zoe_zoe_enemies_zoe_enemy_h

#include <zoe_attack_effects/zoe_attack_effect_slice.h>
#include <zoe_damage/zoe_damage.h>
#include <zoe_data/zoe_data_enemy.h>

#include <math_c_vector.h>

#include <metil.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_scenes/metil_scene.h>

#define zoe_enemy_default_health_maximum 5
#define zoe_enemy_default_health zoe_enemy_default_health_maximum

struct zoe_enemy;

typedef void (*zoe_enemy_function_poll)(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_enemy* _Nonnull
);

typedef void (*zoe_enemy_function_poll_data)(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_enemy* _Nonnull
);

typedef void (*zoe_enemy_function_damage)(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
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
  struct math_c_vector3_float* _Nonnull size;

  unsigned long int time_damaged;
  unsigned long int time_attacked;
  unsigned long int time_range;

  unsigned long int rate_attack;

  float range;

  zoe_enemy_function_poll _Nonnull poll;
  zoe_enemy_function_poll_data _Nonnull poll_data;
  zoe_enemy_function_damage _Nonnull damage;
  zoe_enemy_function_destroy _Nonnull destroy;

  struct zoe_attack_effects_controller* _Nonnull attack_effects_controller;

  void* _Nullable data;
};

void zoe_enemy_initialize(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull,
  struct metil_renderable* _Nonnull,
  struct zoe_attack_effects_controller* _Nonnull
);

void zoe_enemy_initialize_with_buffer_data(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull,
  struct metil_renderable* _Nonnull,
  struct zoe_attack_effects_controller* _Nonnull
);

_Nonnull zoe_enemy_function_poll_data zoe_enemy_function_poll_data_get(
  enum metil_renderable_type
);

void zoe_enemy_buffer_data_add(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull
);

void zoe_enemy_buffer_data_add_object(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull
);

void zoe_enemy_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_enemy* _Nonnull
);

void zoe_enemy_data_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_enemy* _Nonnull
);

void zoe_enemy_damage(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_enemy* _Nonnull,
  struct zoe_damage* _Nonnull
);

void zoe_enemy_destroy(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull
);

void zoe_enemy_default_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_enemy* _Nonnull
);

void zoe_enemy_default_poll_data_object(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_enemy* _Nonnull
);

void zoe_enemy_default_poll_data_null(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_enemy* _Nonnull
);

void zoe_enemy_default_poll_data_enemy(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_enemy* _Nonnull,
  struct zoe_data_enemy* _Nonnull
);

void zoe_enemy_default_damage(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_enemy* _Nonnull,
  struct zoe_damage* _Nonnull
);

void zoe_enemy_default_destroy(
  struct metil* _Nonnull,
  struct zoe_enemy* _Nonnull
);

#endif
