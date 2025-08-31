#ifndef __application_zoe_application_delegate_h
#define __application_zoe_application_delegate_h

#include <AppKit/AppKit.h>

@interface zoe_application_delegate: NSObject<NSApplicationDelegate>

- (void) applicationWillTerminate:(NSNotification*) notification;

@end

#endif
