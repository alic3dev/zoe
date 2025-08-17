#import <zoe.h>

#include <application/zoe_application_delegate.h>
#include <input/map.h>
#include <paths.h>
#include <state_controller.h>
#include <termination.h>

#include <interrupt_handler.h>

#import <Cocoa/Cocoa.h>

void terminate_on_signal(int _) {
  [[NSApplication sharedApplication] terminate: 0];
}

int main(
  int length_parameters,
  const char** parameters
) {
  paths_initialize(
    (char*) parameters[0]
  );

  termination_initialize();
  interrupt_handler_initialize();
  input_maps_initialize();
  state_controller_initialize();

  termination_on_function_add(
    state_controller_destroy,
    (void*)0
  );
  termination_on_function_add(
    interrupt_handler_destroy,
    (void*)0
  );
  termination_on_function_add(
    paths_destroy,
    (void*)0
  );

  NSApplication* application = [NSApplication sharedApplication];
  application.delegate = [zoe_application_delegate alloc];

  interrupt_handler_interrupt_function_add(
    terminate_on_signal
  );
  
  return NSApplicationMain(
    length_parameters,
    parameters
  );
}
