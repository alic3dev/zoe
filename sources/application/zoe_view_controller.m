#include <application/zoe_view_controller.h>

#include <application/zoe_view.h>
#include <input/keycodes.h>
#include <input/map.h>
#include <menus/menu.h>
#include <rendering/zoe_renderer.h>
#include <termination.h>

#include <stdio.h>

@implementation zoe_view_controller {
  zoe_view* view;
  zoe_renderer* renderer;
}

- (void) loadView {
  printf("Loadview\n");
  NSRect rect_frame;
  rect_frame.origin.x = 0;
  rect_frame.origin.y = 0;
  rect_frame.size.width = 100;
  rect_frame.size.height = 100;

  self.view = [[NSView alloc] initWithFrame: rect_frame];

  printf("%i\n", self.view.window);
  
  printf("Loadview:done\n");
}

- (void) viewDidLoad {
  printf("JKZLCXVJLK\n");

  [super viewDidLoad];

  view = (zoe_view*) self.view;
  view.device = MTLCreateSystemDefaultDevice();

  renderer = [
    [zoe_renderer alloc]
    initWithMetalKitView: view
  ];

  [renderer
    drawableSizeWillChange: view.bounds.size
  ];

  view.delegate = self;
}

- (void) drawInMTKView: (nonnull zoe_view*) _view {
  [renderer
    drawInMTKView: _view
  ];
}

- (void) mtkView: (nonnull zoe_view*) _view drawableSizeWillChange: (CGSize) size {
  [renderer
    drawableSizeWillChange: _view.bounds.size
  ];
}

@end
