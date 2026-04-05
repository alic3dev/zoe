#ifndef __zoe_items_zoe_item_h
#define __zoe_items_zoe_item_h

enum zoe_item_type {
  zoe_item_type_consumable = 0x00
};

struct zoe_item {
  enum zoe_item_type type;
};

#endif

