#ifndef __zoe_scenes_scene_intro_forest_scene_intro_forest_loading_h
#define __zoe_scenes_scene_intro_forest_scene_intro_forest_loading_h

#include <zoe_loading_threads.h>

#include <metil.h>
#include <metil_scenes/metil_scene.h>

unsigned char zoe_scene_intro_forest_loading_initialize_function(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  unsigned char,
  void* _Nonnull * _Nullable
);

void zoe_scene_intro_forest_loading_initialize_threaded_function(
  struct zoe_loading_threads_data* _Nonnull
);

float zoe_scene_intro_forest_loading_poll_function(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  unsigned char,
  void* _Nonnull * _Nullable
);

void zoe_scene_intro_forest_loading_finished_function(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  unsigned char,
  void* _Nonnull * _Nullable
);

#endif
