#ifndef __zoe_zoe_damage_zoe_damage_h
#define __zoe_zoe_damage_zoe_damage_h

#include <zoe_damage/zoe_damage_type.h>

struct zoe_damage {
  unsigned int amount_primary;
  unsigned char type_primary;

  unsigned int amount_secondary;
  unsigned char type_secondary;
};

void zoe_damage_initialize(
  struct zoe_damage*
);

void zoe_damage_initialize_with_attributes(
  struct zoe_damage*,
  unsigned int,
  unsigned char,
  unsigned int,
  unsigned char
);

#endif
