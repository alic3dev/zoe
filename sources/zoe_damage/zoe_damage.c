#include <damage/zoe_damage.h>

void zoe_damage_initialize(
  struct zoe_damage* zoe_damage
) {
  zoe_damage_initialize_with_attributes(
    zoe_damage,
    0x00,
    zoe_damage_type_basic,
    0x00,
    zoe_damage_type_none
  );
}

void zoe_damage_initialize_with_attributes(
  struct zoe_damage* zoe_damage,
  unsigned int amount_primary,
  unsigned char type_primary,
  unsigned int amount_secondary,
  unsigned char type_secondary
) {
  zoe_damage->amount_primary = (
    amount_primary
  );

  zoe_damage->type_primary = (
    type_primary
  );

  zoe_damage->amount_secondary = (
    amount_secondary
  );

  zoe_damage->type_secondary = (
    type_secondary
  );
}
