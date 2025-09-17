#ifndef __zoe_h
#define __zoe_h

#include <metil_rendering/rendering_properties.h>

#include <MetalKit/MetalKit.h>

extern id<MTLDevice> _Nullable metal_kit_device;

int main(
  int,
  const char* _Nonnull * _Nonnull
);

void zoe_renderer_on_initialize(
  _Nonnull id<MTLDevice>,
  struct metil_rendering_properties* _Nonnull
);

void zoe_on_scene_change(
  int,
  void* _Nullable
);

#endif
