#ifndef __input_h
#define __input_h

#include <keycodes.h>

extern unsigned char input_map_keydown[keycode_max_value + 1];

void input_initialize();

#endif
