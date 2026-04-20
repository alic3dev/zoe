#ifndef __zoe_weapons_zoe_weapon_targeting_h
#define __zoe_weapons_zoe_weapon_targeting_h

#include <weapons/zoe_weapon.h>

#include <math_c_vector.h>

float zoe_weapon_targeting_frontal_radial_half(
  struct zoe_weapon*,
  struct math_c_vector3_float*,
  struct math_c_vector3_float*,
  struct math_c_vector3_float*,
  struct math_c_vector3_float*
);

#endif
