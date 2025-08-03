#include <application/zoe_application_delegate.h>

#include <input.h>

#include <interrupt_handler.h>

@implementation zoe_application_delegate {}

- (void) applicationWillTerminate: (NSNotification*) notification {
  input_destroy();
  interrupt_handler_destroy();
}

@end
