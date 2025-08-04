#ifndef __menus_menu_intro_h
#define __menus_menu_intro_h

#include <menus/menu.h>

typedef void (*menu_intro_on_start)();
typedef void (*menu_intro_on_exit)();

void menu_intro_initialize(
  struct menu*,
  menu_intro_on_start,
  menu_intro_on_exit
);

void menu_intro_passthrough_on_action(struct menu_item*);

#endif
