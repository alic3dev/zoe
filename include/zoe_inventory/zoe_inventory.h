#ifndef __zoe_zoe_inventory_zoe_inventory_h
#define __zoe_zoe_inventory_zoe_inventory_h

#include <zoe_inventory/zoe_inventory_item.h>

struct zoe_inventory {
  unsigned char length_items;
  unsigned char length_maximum_items;

  struct zoe_inventory_item** items;
};

void zoe_inventory_initialize(
  struct zoe_inventory*
);

unsigned char zoe_inventory_item_add(
  struct zoe_inventory*,
  enum zoe_inventory_item_type,
  void*
);

void zoe_inventory_destroy(
  struct zoe_inventory*
);

#endif
