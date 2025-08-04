#include <menus/menu_intro.h>

#include <menus/menu.h>
#include <menus/menu_item.h>

void menu_intro_initialize(
  struct menu* menu,
  menu_intro_on_start on_start,
  menu_intro_on_exit on_exit
) {
  menu_initialize(menu);

  menu_item_add(
    menu,
    menu_item_type_selection,
    menu_item_action_start,
    menu_intro_passthrough_on_action,
    on_start
  );

  menu_item_add(
    menu,
    menu_item_type_selection,
    menu_item_action_exit,
    menu_intro_passthrough_on_action,
    on_exit
  );
}

void menu_intro_passthrough_on_action(
  struct menu_item* menu_item
) {
  switch(
    menu_item->action
  ) {
    case menu_item_action_start:
      ((menu_intro_on_start)menu_item->data)();
      break;
    case menu_item_action_exit:
      ((menu_intro_on_exit)menu_item->data)();
      break;
    default:
      break;
  }
}
