#include <weapons/zoe_weapon_targeting.h>

#include <weapons/zoe_weapon.h>

#include <math_c_vector.h>
#include <math_c_vector_distance.h>

float zoe_weapon_targeting_frontal_radial_half(
  struct zoe_weapon* zoe_weapon,
  struct math_c_vector3_float* position_player,
  struct math_c_vector3_float* rotation_player,
  struct math_c_vector3_float* position_enemy,
  struct math_c_vector3_float* size_enemy
) {
  float distance = (
    math_c_vector3_distance_float_fastest(
      position_player,
      position_enemy
    )
  );

  if (
    distance >
    zoe_weapon->range
  ) {
    return (
      0x00
    );
  }

  return (
    (
      zoe_weapon->range -
      distance
    ) /
    zoe_weapon->range
  );
}
