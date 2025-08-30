#ifndef __application_zoe_application_delegate_h
#define __application_zoe_application_delegate_h

#import <AppKit/AppKit.h>

@interface zoe_application_delegate: NSObject<NSApplicationDelegate>

- (void) applicationDidFinishLaunching:(NSNotification *) notification;
- (void) applicationWillTerminate:(NSNotification*) notification;

@end

#endif
