#ifndef __zoe_renderer_h
#define __zoe_renderer_h

#include <metal_kit_shader_types.h>

#include <MetalKit/MetalKit.h>

@interface zoe_renderer : NSObject<MTKViewDelegate>

- (nonnull instancetype) initWithMetalKitView: (nonnull MTKView*) metal_kit_view;
- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view;
- (void) drawableSizeWillChange: (CGSize) size;
- (void) destroy;

@property (nonatomic) float position;

@end

void zoe_renderer_on_termination(void* _Nonnull);

#endif
