#ifndef __application_zoe_application_h
#define __application_zoe_application_h

#import <AppKit/AppKit.h>

@interface zoe_window: NSWindow

- (void) keyDown:(NSEvent *) event;
- (void) keyUp:(NSEvent *) event;
- (BOOL) canBecomeKeyWindow;

@end

#endif
