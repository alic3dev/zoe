#include <application/zoe_application_delegate.h>

#include <interrupt_handler.h>

@implementation zoe_application_delegate {}

- (void) applicationWillTerminate: (NSNotification*) notification {
  interrupt_handler_destroy();
}

@end
