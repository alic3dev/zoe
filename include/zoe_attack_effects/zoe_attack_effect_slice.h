#ifndef __zoe_zoe_attack_effects_zoe_attack_effect_slice_h
#define __zoe_zoe_attack_effects_zoe_attack_effect_slice_h

#include <zoe_attack_effects/zoe_attack_effect.h>

#include <math_c_vector.h>

#include <metil.h>
void zoe_attack_effect_slice_initialize(
  struct metil* _Nonnull,
  struct zoe_attack_effect* _Nonnull,
  struct math_c_vector3_float* _Nonnull,
  struct math_c_vector3_float* _Nonnull
);

#endif
