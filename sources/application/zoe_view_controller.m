#include <application/zoe_view_controller.h>

#include <application/zoe_view.h>
#include <rendering/zoe_renderer.h>

@implementation zoe_view_controller {
  zoe_view* view;
  zoe_renderer* renderer;
}

- (void) viewDidLoad {
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
