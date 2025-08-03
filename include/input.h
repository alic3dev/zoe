#ifndef __input_h
#define __input_h

#include <keycodes.h>

#include <pthread.h>

#include <CoreFoundation/CoreFoundation.h>
#include <CoreGraphics/CoreGraphics.h>

extern unsigned char input_map_keydown[keycode_max_value + 1];

extern CFMachPortRef mach_port_reference;
extern CFRunLoopRef input_run_loop_reference;

struct __CGEvent* tap_event(
  struct __CGEventTapProxy*,
  CGEventType,
  struct __CGEvent*,
  void*
);

void* input_thread(void*);

int input_initialize();

#endif
