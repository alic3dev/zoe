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
    0x04
  );

  zoe_inventory->items = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_inventory_item*
      ) *
      zoe_inventory->length_items
    )
  );

  for (
    unsigned char index_item = (
      0x00
    );
    (
      index_item <
      zoe_inventory->length_items
    );
    ++index_item
  ) {
    zoe_inventory->items[
      index_item
    ] = (
      clic3_memory_allocate_raw(
        sizeof(
          struct zoe_inventory_item
        )
      )
    );
  }
}

unsigned char zoe_inventory_item_add(
  struct zoe_inventory* zoe_inventory,
  enum zoe_inventory_item_type zoe_inventory_item_type,
  void* zoe_inventory_item_item
) {
  if (
    (
      zoe_inventory->length_items +
      0x01
    ) >=
    zoe_inventory->length_maximum_items
  ) {
    return (
      0x01
    );
  }

  zoe_inventory->length_items = (
    zoe_inventory->length_items +
    0x01
  );

  clic3_memory_reallocate_raw(
    &zoe_inventory->items,
    (
      sizeof(
        struct zoe_inventory_item*
      ) *
      zoe_inventory->length_items
    )
  );

  zoe_inventory->items[
    zoe_inventory->length_items -
    0x01
  ] = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_inventory_item
      )
    )
  );

  struct zoe_inventory_item* zoe_inventory_item = (
    zoe_inventory->items[
      zoe_inventory->length_items -
      0x01
    ]
  );

  zoe_inventory_item->type = (
    zoe_inventory_item_type
  );

  zoe_inventory_item->item = (
    zoe_inventory_item_item
  );

  return (
    0x00
  ); 
}

void zoe_inventory_destroy(
  struct zoe_inventory* zoe_inventory
) {
  for (
    unsigned char index_item = (
      0x00
    );
    (
      index_item <
      zoe_inventory->length_items
    );
    ++index_item
  ) {
    clic3_memory_free_raw(
      zoe_inventory->items[
        index_item
      ]->item
    );

    clic3_memory_free_raw(
      zoe_inventory->items[
        index_item
      ]
    );
  }

  clic3_memory_free_raw(
    zoe_inventory->items
  );
}
