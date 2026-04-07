#include <weapons/zoe_weapon_mapping.h>

#include <weapons/zoe_weapon.h>
#include <weapons/zoe_weapon_id.h>
#include <weapons/zoe_weapon_knife.h>

const struct zoe_weapon* zoe_weapon_mapping_id_to_structure(
  unsigned short int id_weapon
) {
  switch (
    id_weapon
  ) {
    case zoe_weapon_id_knife: {
      return &(
        zoe_weapon_knife
      );
    }
    default: {
      return (
        0x00
      );
    }
  }
}
