#include <weapons/zoe_weapon_knife.h>

#include <damage/zoe_damage_type.h>
#include <weapons/zoe_weapon.h>
#include <weapons/zoe_weapon_damage.h>
#include <weapons/zoe_weapon_id.h>
#include <weapons/zoe_weapon_targeting.h>

const struct zoe_weapon zoe_weapon_knife = {
  .id = (
    zoe_weapon_id_knife
  ),
  .handedness = (
    zoe_weapon_handedness_ambi
  ),
  .type = (
    zoe_weapon_type_melee_sharp
  ),
  .durability_type = (
    zoe_weapon_durability_type_unbreakable
  ),
  .durability = (
    0x00
  ),
  .targeting = (
    zoe_weapon_targeting_frontal_radial_half
  ),
  .damage = (
    zoe_weapon_damage_flat
  ),
  .range = (
    0x20
  ),
  .rate = (
    0x03e8
  ),
  .type_damage_primary = (
    zoe_damage_type_basic
  ),
  .type_damage_secondary = (
    zoe_damage_type_none
  ),
  .amount_damage_base_primary = (
    0x01
  ),
  .amount_damage_base_secondary = (
    0x00
  )
};
