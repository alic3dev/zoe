#ifndef __zoe_h
#define __zoe_h

#include <metil.h>

#if target_os_ios
extern char* _Nonnull zoe_executable_path;
#endif

int main(
  int,
  #if target_os_ios
  char* _Nonnull * _Nonnull
  #else
  const char* _Nonnull * _Nonnull
  #endif
);

#if target_os_ios
void zoe_view_controller_on_view_did_load();
#endif

void zoe_renderer_on_initialize(
  struct metil* _Nonnull metil,
  void* _Nullable
);

void zoe_on_scene_change(
  struct metil* _Nonnull,
  int,
  void* _Nonnull
);

void zoe_destroy(
  struct metil* _Nonnull
);

#endif
