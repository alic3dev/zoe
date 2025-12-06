#if target_os_ios
#include <application/zoe_application_delegate.h>

#include <metil_termination.h>

@implementation zoe_application_delegate {}

- (BOOL) application:(UIApplication*) application didFinishLaunchingWithOptions:(NSDictionary*) launchOptions {
  return 1;
}

- (void) applicationWillTerminate: (NSNotification*) notification {
  metil_termination_terminate();
}

@end
#endif
