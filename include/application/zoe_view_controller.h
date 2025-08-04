#ifndef __application_zoe_view_controller_h
#define __application_zoe_view_controller_h

#import <zoe_renderer.h>

#include <MetalKit/MetalKit.h>

void zoe_view_controller_on_termination();

@interface zoe_view_controller: NSViewController<MTKViewDelegate>
@end

#endif
