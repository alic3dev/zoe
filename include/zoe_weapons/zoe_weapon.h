#ifndef __zoe_zoe_weapons_zoe_weapon_h
#define __zoe_zoe_weapons_zoe_weapon_h

#include <zoe_damage/zoe_damage.h>

#include <math_c_vector.h>

enum zoe_weapon_handedness {
  zoe_weapon_handedness_left  = 0x00,
  zoe_weapon_handedness_right = 0x01,
  zoe_weapon_handedness_dual  = 0x02,
  zoe_weapon_handedness_ambi  = 0x03
};

enum zoe_weapon_type {
  zoe_weapon_type_melee_blunt       = 0x00,
  zoe_weapon_type_melee_sharp       = 0x01,
  zoe_weapon_type_ranged_gun        = 0x02,
  zoe_weapon_type_ranged_thrown     = 0x03,
  zoe_weapon_type_ranged_projectile = 0x04
};

enum zoe_weapon_durability_type {
  zoe_weapon_durability_type_breakable   = 0x00,
  zoe_weapon_durability_type_unbreakable = 0x01
};

struct zoe_weapon;

typedef float (*zoe_weapon_function_targeting) (
  struct zoe_weapon*,
  struct math_c_vector3_float*,
  struct math_c_vector3_float*,
  struct math_c_vector3_float*,
  struct math_c_vector3_float*
);

typedef struct zoe_damage* (*zoe_weapon_function_damage) (
  struct zoe_weapon*,
  float
);

struct zoe_weapon {
  unsigned short int id;

  enum zoe_weapon_handedness handedness;
  enum zoe_weapon_type type;
  enum zoe_weapon_durability_type durability_type;
  unsigned int durability;

  zoe_weapon_function_targeting targeting;
  zoe_weapon_function_damage damage;

  float range;
  unsigned int rate;

  unsigned char type_damage_primary;
  unsigned char type_damage_secondary;

  unsigned int amount_damage_base_primary;
  unsigned int amount_damage_base_secondary;
};

#endif
