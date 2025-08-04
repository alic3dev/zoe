#include <menus/menu_item.h>

void menu_item_initialize(
  struct menu_item* menu_item,
  enum menu_item_type type,
  enum menu_item_action action,
  menu_item_on_action on_action,
  void* data
) {
  menu_item->type = type;
  menu_item->action = action;
  menu_item->on_action = on_action;
  menu_item->data = data;
}

void menu_item_select(
  struct menu_item* menu_item
) {
  menu_item->on_action(menu_item);
}

void menu_item_on_action_none(struct menu_item* _) {}
