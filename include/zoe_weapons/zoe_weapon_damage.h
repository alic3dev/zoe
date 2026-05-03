#ifndef __zoe_weapons_zoe_weapon_damage_h
#define __zoe_weapons_zoe_weapon_damage_h

#include <zoe_damage/zoe_damage.h>
#include <zoe_weapons/zoe_weapon.h>

struct zoe_damage* zoe_weapon_damage_flat(
  struct zoe_weapon*,
  float
);

#endif
