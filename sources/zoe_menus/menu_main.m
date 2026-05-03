#include <zoe_menus/menu_main.h>

#include <metil_menus/metil_menu.h>
#include <metil_menus/metil_menu_item.h>

void menu_main_initialize(
  struct metil_menu* menu
) {
  metil_menu_initialize(
    menu
  );

  metil_menu_item_add(
    menu,
    metil_menu_item_type_selection,
    metil_menu_item_action_select,
    0x00
  );

  metil_menu_item_add(
    menu,
    metil_menu_item_type_selection,
    metil_menu_item_action_select,
    0x00
  );
}
