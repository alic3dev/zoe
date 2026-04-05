#ifndef __zoe_inventory_zoe_inventory_h
#define __zoe_inventory_zoe_inventory_h

#include <inventory/zoe_inventory_item.h>

struct zoe_inventory {
  unsigned char length_items;
  unsigned char length_maximum_items;

  struct zoe_inventory_item* items;
};

#endif

