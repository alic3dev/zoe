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
  if (event.keyCode < input_map_keydown_length) {
    input_map_keydown[
      event.keyCode
    ] = 0;
  }
}

- (void) flagsChanged:(NSEvent*) event {
  // TODO: Find whatever flag determines if this is a keyup or keydown
  if (event.keyCode < input_map_keydown_length) {
    input_map_keydown[
      event.keyCode
    ] = input_map_keydown[
      event.keyCode
    ] == 1 ? 0 : 1;
  }
}

- (BOOL) canBecomeKeyWindow {
  return 1;
}

@end
