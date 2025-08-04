#include <application/zoe_application_delegate.h>

#include <termination.h>

@implementation zoe_application_delegate {}

- (void) applicationWillTerminate: (NSNotification*) notification {
  termination_terminate();
}

@end
