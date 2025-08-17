#ifndef __application_zoe_view_controller_h
#define __application_zoe_view_controller_h

#include <menus/menu.h>

#include <MetalKit/MetalKit.h>

extern struct menu menu_intro;
extern unsigned char menu_closing;

void zoe_view_controller_on_termination();

@interface zoe_view_controller: NSViewController<MTKViewDelegate>
@end

#endif
