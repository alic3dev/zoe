#include <application/zoe_application_delegate.h>

#include <application/zoe_view.h>
#include <application/zoe_view_controller.h>
#include <application/zoe_window.h>

#include <termination.h>

#include <stdio.h>

#include <AppKit/NSWindow.h>

@implementation zoe_application_delegate {}

- (void) applicationDidFinishLaunching:(NSNotification *) notification {
  NSRect rect_content;
  rect_content.origin.x = 0;
  rect_content.origin.y = 0;
  rect_content.size.width = 100;
  rect_content.size.height = 100;

  zoe_window* window = [[zoe_window alloc]
    initWithContentRect: rect_content
    styleMask: NSWindowStyleMaskBorderless
    backing: NSBackingStoreBuffered
    defer:0
    // screen: [NSScreen mainScreen]
  ];

  zoe_view_controller* view_controller = [zoe_view_controller alloc];
  // [view_controller loadView];

  printf("%i\n", window);

  [window makeKeyWindow];
  // [window makeMainWindow];

  

  printf("38249\n");

  // view_controller.view.window

  window.contentViewController = view_controller;

  printf("setviewcontroller\n");
  // [window makeMainWindow];
  
}

- (void) applicationWillTerminate: (NSNotification*) notification {
  termination_terminate();
}

@end
