#ifndef __zoe_zoe_attack_effects_zoe_attack_effects_controller_h
#define __zoe_zoe_attack_effects_zoe_attack_effects_controller_h

#include <zoe_attack_effects/zoe_attack_effect.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_scenes/metil_scene.h>

struct zoe_attack_effects_controller {
  struct zoe_attack_effect* _Nonnull * _Nonnull attack_effects;
  struct metil_group* _Nonnull group;

  unsigned long int* _Nonnull time;
};

void zoe_attack_effects_controller_initialize(
  struct zoe_attack_effects_controller* _Nonnull,
  struct metil_group* _Nonnull,
  unsigned long int* _Nonnull
);

struct zoe_attack_effect* _Nonnull zoe_attack_effects_controller_add(
  struct zoe_attack_effects_controller* _Nonnull
);

void zoe_attack_effects_controller_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct zoe_attack_effects_controller* _Nonnull
);

void zoe_attack_effects_controller_destroy(
  struct zoe_attack_effects_controller* _Nonnull
);

#endif
