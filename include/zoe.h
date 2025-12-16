#ifndef __zoe_h
#define __zoe_h

#include <metil_rendering/metil_renderer_interface.h>

int main(
  int,
  #if target_os_ios
  char* _Nonnull * _Nonnull
  #else
  const char* _Nonnull * _Nonnull
  #endif
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
