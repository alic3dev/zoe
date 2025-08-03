#include <input.h>

#include <keycodes.h>

unsigned char input_map_keydown[keycode_max_value + 1];

void input_initialize() {
  for (
    unsigned char index_keycode = 0;
    index_keycode <= keycode_max_value;
    ++index_keycode
  ) {
    input_map_keydown[
      index_keycode
    ] = 0;
  }
}
