#import <zoe.h>

#include <application/zoe_application_delegate.h>
#include <input.h>

#include <interrupt_handler.h>

#import <Cocoa/Cocoa.h>

void terminate_on_signal() {
  [[NSApplication sharedApplication] terminate: 0];
}

int main(
  int length_parameters,
  const char** parameters
) {
  interrupt_handler_initialize();

  int status_input_initialization = (
    input_initialize()
  );

  if (status_input_initialization != 0) {
    return status_input_initialization;
  }

  interrupt_handler_interrupt_function_add(
    terminate_on_signal
  );

  NSApplication* application = [NSApplication sharedApplication];
  application.delegate = [zoe_application_delegate alloc];
  
  return NSApplicationMain(
    length_parameters,
    parameters
  );
}
