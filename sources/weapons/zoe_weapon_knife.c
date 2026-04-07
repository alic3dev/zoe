#include <weapons/zoe_weapon_knife.h>

#include <weapons/zoe_weapon.h>
#include <weapons/zoe_weapon_id.h>

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
  )
};
