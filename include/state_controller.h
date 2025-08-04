#ifndef __state_controller_h
#define __state_controller_h

enum state_enumeration {
  menu_main,
  running,
  exiting
};

typedef void (*state_controller_on_state_change)(enum state_enumeration);

struct state_controller_structure {
  enum state_enumeration state;

  unsigned char length_on_state_change;
  state_controller_on_state_change* on_state_change;
};

extern struct state_controller_structure state_controller;

void state_controller_initialize();

void state_controller_on_state_change_add(
  state_controller_on_state_change
);

void state_controller_destroy();

#endif
