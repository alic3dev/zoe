#ifndef __zoe_weapons_zoe_weapon_h
#define __zoe_weapons_zoe_weapon_h

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

struct zoe_weapon {
  unsigned short int id;

  enum zoe_weapon_handedness handedness;
  enum zoe_weapon_type type;
  enum zoe_weapon_durability_type durability_type;
  unsigned int durability;
};

#endif

