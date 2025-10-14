#ifndef __zoe_h
#define __zoe_h

#include <metil_rendering/metil_renderer_interface.h>

int main(
  int,
  const char* _Nonnull * _Nonnull
);

void zoe_renderer_on_initialize(
  struct metil_renderer_interface* _Nonnull metil_renderer_interface,
  void* _Nullable
);

void zoe_on_scene_change(
  int,
  void* _Nonnull
);

#endif
