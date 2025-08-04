#include <application/zoe_window.h>

#include <input/map.h>

@implementation zoe_window {}

- (void) keyDown: (NSEvent*) event {
  unsigned short int code_key = event.keyCode;

  if (event.keyCode < input_map_keydown_length) {
    input_map_keydown[
      code_key
    ] = 1;
  }
}

- (void) keyUp: (NSEvent*) event {
  unsigned short int code_key = event.keyCode;

  if (event.keyCode < input_map_keydown_length) {
    input_map_keydown[
      code_key
    ] = 0;
  }
}

- (BOOL) canBecomeKeyWindow {
  return 1;
}

@end
