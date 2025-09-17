#ifndef __zoe_h
#define __zoe_h

#include <MetalKit/MetalKit.h>

extern id<MTLDevice> _Nullable metal_kit_device;

int main(
  int,
  const char* _Nonnull * _Nonnull
);

void zoe_renderer_on_initialize(
  _Nonnull id<MTLDevice>
);

void zoe_on_scene_change(
  int,
  void* _Nullable
);

#endif
