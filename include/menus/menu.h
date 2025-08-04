#ifndef __menus_menu_h
#define __menus_menu_h

#include <menus/menu_item.h>

struct menu;

typedef void (*menu_on_selection_change)(struct menu*);

struct menu {
  unsigned char index_selected;
  menu_on_selection_change on_selection_change;
  
  unsigned char length_items;
  struct menu_item* items;

  unsigned char wrap;
};

void menu_initialize(
  struct menu*
);

void menu_item_add(
  struct menu*,
  enum menu_item_type,
  enum menu_item_action,
  menu_item_on_action,
  void*
);

void menu_select(
  struct menu*
);

unsigned char menu_index_selected_set(
  struct menu*,
  unsigned char
);

unsigned char menu_next(
  struct menu*
);

unsigned char menu_previous(
  struct menu*
);


void menu_on_selection_change_call(
  struct menu*
);

void menu_destroy(
  struct menu*
);

#endif
