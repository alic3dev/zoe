#include <zoe_weapons/zoe_weapon_damage.h>

#include <zoe_damage/zoe_damage.h>
#include <zoe_weapons/zoe_weapon.h>

#include <clic3_memory.h>

struct zoe_damage* zoe_weapon_damage_flat(
  struct zoe_weapon* zoe_weapon,
  float distance_ranged
) {
  if (
    distance_ranged ==
    0x00
  ) {
    return (
      0x00
    );
  }

  static struct zoe_damage* zoe_damage;

  zoe_damage = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_damage
      )
    )
  );

  zoe_damage_initialize_with_attributes(
    zoe_damage,
    zoe_weapon->amount_damage_base_primary,
    zoe_weapon->type_damage_primary,
    zoe_weapon->amount_damage_base_secondary,
    zoe_weapon->type_damage_secondary
  );

  return (
    zoe_damage
  );
}
