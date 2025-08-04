#include <menus/menu.h>

#include <menus/menu_item.h>

#include <stdlib.h>

void menu_initialize(
  struct menu* menu
) {
  menu->index_selected = 0;

  menu->length_items = 0;
  menu->items = malloc(
    sizeof(struct menu_item) *
    menu->length_items
  );

  menu->wrap = 0;
}

void menu_item_add(
  struct menu* menu,
  enum menu_item_type type,
  enum menu_item_action action,
  menu_item_on_action on_action,
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
    on_action,
    data
  );
}

void menu_select(
  struct menu* menu
) {
  if (menu->length_items == 0) {
    return;
  }

  menu_item_select(
    &menu->items[
      menu->index_selected
    ]
  );
}

unsigned char menu_index_selected_set(
  struct menu* menu,
  unsigned char index_selected
) {
  if (
    index_selected >= menu->length_items ||
    index_selected == menu->index_selected
  ) {
    return 1;
  }

  menu_on_selection_change_call(
    menu
  );

  return 0;
}

unsigned char menu_next(
  struct menu* menu
) {
  if (
    menu->index_selected == menu->length_items - 1
  ) {
    if (menu->wrap == 0) {
      return 1;
    }

    menu->index_selected = 0;
  } else {
    menu->index_selected = (
      menu->index_selected + 1
    );
  }

  menu_on_selection_change_call(
    menu
  );

  return 0;
}

unsigned char menu_previous(
  struct menu* menu
) {
  if (
    menu->index_selected == 0
  ) {
    if (menu->wrap == 0) {
      return 1;
    }

    menu->index_selected = (
      menu->length_items - 1
    );
  } else {
    menu->index_selected = (
      menu->index_selected - 1
    );
  }

  menu_on_selection_change_call(
    menu
  );

  return 0;
}

void menu_on_selection_change_call(
  struct menu* menu
) {
  if (
    menu->on_selection_change != (void*)0
  ) {
    menu->on_selection_change(
      menu
    );
  }
}

void menu_destroy(
  struct menu* menu
) {
  free(menu->items);
}
