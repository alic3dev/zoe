#ifndef __zoe_zoe_attack_effects_zoe_attack_effect_h
#define __zoe_zoe_attack_effects_zoe_attack_effect_h

#include <metil.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable.h>

struct zoe_attack_effect {
  struct metil_renderable* _Nonnull renderable;

  unsigned long int length;
  unsigned long int time_started;
};

void zoe_attack_effect_initialize(
  struct zoe_attack_effect* _Nonnull,
  struct metil_renderable* _Nonnull,
  unsigned long int
);

void zoe_attack_effect_buffer_data_add(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  unsigned int,
  unsigned int
);

#endif
