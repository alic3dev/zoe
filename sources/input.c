#include <input.h>

#include <interrupt_handler.h>

#include <pthread.h>
#include <signal.h>
#include <stdio.h>

#include <CoreFoundation/CoreFoundation.h>
#include <CoreGraphics/CoreGraphics.h>

CFMachPortRef mach_port_reference;
CFRunLoopRef input_run_loop_reference;

void handler_interrupt() {
  CFRunLoopStop(input_run_loop_reference);
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
  
  CFRelease(mach_port_reference);

  return 0;
}

struct __CGEvent* tap_event(
  struct __CGEventTapProxy * proxy_tap_event,
  CGEventType type_event,
  struct __CGEvent *event,
  void* data_user
) {
  if (type_event == kCGEventKeyDown) {
    fprintf(
      data_user,
      "key_down: "
    );
  } else if (type_event == kCGEventKeyUp) {
    fprintf(
      data_user,
      "key_up: "
    );
  }

  long long int code_key = CGEventGetIntegerValueField(
    event,
    kCGKeyboardEventKeycode
  );

  fprintf(
    data_user,
    "%lli\n",
    code_key
  );

  return event;
}

int input_initialize() {
  CGEventMask mask_event = CGEventMaskBit(kCGEventKeyDown) | CGEventMaskBit(kCGEventKeyUp);

  mach_port_reference = CGEventTapCreate(
    kCGAnnotatedSessionEventTap,
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

  interrupt_handler_interrupt_function_add(handler_interrupt);

  pthread_t pthread_cleanup;

  return pthread_create(
    &pthread_cleanup,
    (void*)0,
    input_thread,
    (void*)0
  );
}
