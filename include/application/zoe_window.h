#ifndef __application_zoe_application_h
#define __application_zoe_application_h

#include <AppKit/AppKit.h>

@interface zoe_window: NSWindow {
  unsigned char locked_cursor;
}

- (void) keyDown:(NSEvent*) event;
- (void) keyUp:(NSEvent*) event;
- (void) mouseDown:(NSEvent *) event;
- (void) mouseMoved: (NSEvent*) event;
- (void) flagsChanged:(NSEvent*) event;

- (BOOL) canBecomeKeyWindow;

@end

#endif
