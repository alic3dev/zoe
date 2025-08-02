#ifndef __input_h
#define __input_h

#include <pthread.h>

#include <CoreFoundation/CoreFoundation.h>
#include <CoreGraphics/CoreGraphics.h>

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
