#ifndef __application_zoe_view_controller_h
#define __application_zoe_view_controller_h

#include <menus/menu.h>

#include <application/zoe_view.h>

#include <MetalKit/MetalKit.h>

@interface zoe_view_controller: NSViewController<MTKViewDelegate>

- (void) loadView;
- (void) viewDidLoad;
- (void) drawInMTKView: (nonnull zoe_view*) _view;
- (void) mtkView: (nonnull zoe_view*) _view drawableSizeWillChange: (CGSize) size;

@end

#endif
