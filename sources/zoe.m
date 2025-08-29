#import <zoe.h>

#include <application/zoe_application.h>
#include <application/zoe_application_delegate.h>
#include <audio/audio.h>
#include <input/input.h>
#include <paths.h>
#include <scenes/scene_controller.h>
#include <termination.h>

#include <interrupt_handler.h>

#include <stdlib.h>
#include <time.h>

#include <Cocoa/Cocoa.h>

void terminate_on_signal(int _) {
  audio_destroy();
  
  [[NSApplication sharedApplication] terminate: 0];
}

int main(
  int length_parameters,
  const char** parameters
) {
  srand(time((void*)0));
  
  paths_initialize(
    (char*) parameters[0]
  );

  termination_initialize();
  interrupt_handler_initialize();
  input_initialize();
  scene_controller_initialize();
  audio_initialize();

  termination_on_function_add(
    scene_controller_destroy,
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

  zoe_application* application = [zoe_application sharedApplication];
  application.delegate = [zoe_application_delegate alloc];

  interrupt_handler_interrupt_function_add(
    terminate_on_signal
  );
  
  return NSApplicationMain(
    length_parameters,
    parameters
  );
}
