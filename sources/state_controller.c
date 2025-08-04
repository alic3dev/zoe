#include <state_controller.h>

#include <stdlib.h>

struct state_controller_structure state_controller = {
  .state = menu_main,
  .length_on_state_change = 0,
  .on_state_change = (void*)0
};

void state_controller_initialize() {
  state_controller.on_state_change = malloc(
    sizeof(state_controller_on_state_change) *
    state_controller.length_on_state_change
  );
}

void state_controller_on_state_change_add(
  state_controller_on_state_change on_state_change
) {
  state_controller.length_on_state_change = (
    state_controller.length_on_state_change + 1
  );

  state_controller.on_state_change = realloc(
    state_controller.on_state_change,
    sizeof(state_controller_on_state_change) *
    state_controller.length_on_state_change
  );
}

void state_controller_destroy() {
  free(state_controller.on_state_change);
}
