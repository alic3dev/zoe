#include <input.h>

#include <keycodes.h>

#include <interrupt_handler.h>

#include <pthread.h>
#include <signal.h>
#include <stdio.h>

#include <CoreFoundation/CoreFoundation.h>
#include <CoreGraphics/CoreGraphics.h>

unsigned char input_map_keydown[keycode_max_value + 1];

pthread_t pthread_input_thread;

CFMachPortRef mach_port_reference;
CFRunLoopRef input_run_loop_reference;

int input_initialize() {
  for (
    unsigned char index_keycode = 0;
    index_keycode <= keycode_max_value;
    ++index_keycode
  ) {
    input_map_keydown[
      index_keycode
    ] = 0;
  }

  CGEventMask mask_event = CGEventMaskBit(kCGEventKeyDown) | CGEventMaskBit(kCGEventKeyUp);

  mach_port_reference = CGEventTapCreateForPid(
    getpid(),
    kCGHeadInsertEventTap,
    kCGEventTapOptionListenOnly,
    mask_event,
    tap_event,
    stdout
  );

  if (mach_port_reference == (void*)0) {
    fprintf(
      stderr,
      "failed_to_create_tap\n"
    );

    return 1;
  }

  return pthread_create(
    &pthread_input_thread,
    (void*)0,
    input_thread,
    (void*)0
  );
}

struct __CGEvent* tap_event(
  struct __CGEventTapProxy * proxy_tap_event,
  CGEventType type_event,
  struct __CGEvent *event,
  void* data_user
) {
  long long int code_key = CGEventGetIntegerValueField(
    event,
    kCGKeyboardEventKeycode
  );

  if (type_event == kCGEventKeyDown) {
    input_map_keydown[
      code_key
    ] = 1;
  } else if (type_event == kCGEventKeyUp) {
    input_map_keydown[
      code_key
    ] = 0;
  }

  return event;
}

void* input_thread(void* _) {
  CFRunLoopSourceRef run_loop_source_reference = CFMachPortCreateRunLoopSource(
    kCFAllocatorDefault,
    mach_port_reference,
    0
  );

  input_run_loop_reference = CFRunLoopGetCurrent();

  CFRunLoopAddSource(
    input_run_loop_reference,
    run_loop_source_reference,
    kCFRunLoopCommonModes
  );

  CFRunLoopRun();

  return (void*)0;
}

void input_destroy() {
  CFRunLoopStop(input_run_loop_reference);
  CFRelease(mach_port_reference);

  pthread_join(
    pthread_input_thread,
    (void*)0
  );
}
