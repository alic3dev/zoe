#include <inventory/zoe_inventory.h>

#include <inventory/zoe_inventory_item.h>

#include <clic3_memory.h>

void zoe_inventory_initialize(
  struct zoe_inventory* zoe_inventory
) {
  zoe_inventory->length_items = (
    0x00
  );

  zoe_inventory->length_maximum_items = (
    0x00
  );

  zoe_inventory->items = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_inventory_item
      ) *
      zoe_inventory->length_items
    )
  );}

void zoe_inventory_destroy(
  struct zoe_inventory* zoe_inventory
) {
  clic3_memory_free_raw(
    zoe_inventory->items
  );
}

