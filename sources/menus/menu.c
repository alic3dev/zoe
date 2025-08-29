#include <menus/menu.h>

#include <menus/menu_item.h>

#include <stdlib.h>

void menu_initialize(
  struct menu* menu
) {
  menu->index_current = 0;

  menu->length_items = 0;
  menu->items = malloc(
    sizeof(struct menu_item) *
    menu->length_items
  );

  menu->index_selected = -1;
  menu->handled = 0;

  menu->wrap = 0;
}

void menu_item_add(
  struct menu* menu,
  enum menu_item_type type,
  enum menu_item_action action,
  void* data
) {
  menu->length_items = (
    menu->length_items + 1
  );

  menu->items = realloc(
    menu->items,
    sizeof(struct menu_item) *
    menu->length_items
  );

  menu_item_initialize(
    &menu->items[
      menu->length_items - 1
    ],
    type,
    action,
    data
  );
}

void menu_select(
  struct menu* menu
) {
  if (menu->length_items == 0) {
    return;
  }

  menu->index_selected = menu->index_current;
}

unsigned char menu_next(
  struct menu* menu
) {
  if (
    menu->index_current == menu->length_items - 1
  ) {
    if (menu->wrap == 0) {
      return 1;
    }

    menu->index_current = 0;
  } else {
    menu->index_current = (
      menu->index_current + 1
    );
  }

  return 0;
}

unsigned char menu_previous(
  struct menu* menu
) {
  if (
    menu->index_current == 0
  ) {
    if (menu->wrap == 0) {
      return 1;
    }

    menu->index_current = (
      menu->length_items - 1
    );
  } else {
    menu->index_current = (
      menu->index_current - 1
    );
  }

  return 0;
}

void menu_destroy(
  struct menu* menu
) {
  free(menu->items);
}
