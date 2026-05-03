#ifndef __zoe_zoe_inventory_zoe_inventory_item_h
#define __zoe_zoe_inventory_zoe_inventory_item_h

enum zoe_inventory_item_type {
  zoe_inventory_item_type_item   = 0x00,
  zoe_inventory_item_type_weapon = 0x01
};

struct zoe_inventory_item {
  enum zoe_inventory_item_type type;

  void* item;
};

#endif
