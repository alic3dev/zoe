#ifndef __zoe_zoe_loading_map_h
#define __zoe_zoe_loading_map_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

typedef unsigned char (*zoe_scene_loading_loading_initialize_function)(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  unsigned char,
  void* _Nonnull * _Nullable
);

typedef float (*zoe_scene_loading_loading_poll_function)(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  unsigned char,
  void* _Nonnull * _Nullable
);

typedef void (*zoe_scene_loading_loading_finished_function)(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  unsigned char,
  void* _Nonnull * _Nullable
);

struct zoe_loading_map {
  zoe_scene_loading_loading_initialize_function _Nonnull initialize;
  zoe_scene_loading_loading_poll_function _Nonnull poll;
  zoe_scene_loading_loading_finished_function _Nonnull finished;
};

void zoe_loading_map_initialize(
  struct zoe_loading_map* _Nonnull,
  unsigned char
);

zoe_scene_loading_loading_initialize_function _Nonnull zoe_loading_map_initialize_function_get(
  unsigned char
);

zoe_scene_loading_loading_poll_function _Nonnull zoe_loading_map_poll_function_get(
  unsigned char
);

zoe_scene_loading_loading_finished_function _Nonnull zoe_loading_map_finished_function_get(
  unsigned char
);

unsigned char zoe_scene_loading_loading_initialize_function_no_load(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  unsigned char,
  void* _Nonnull * _Nullable
);

float zoe_scene_loading_loading_poll_function_no_load(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  unsigned char,
  void* _Nonnull * _Nullable
);

void zoe_scene_loading_loading_finished_function_no_load(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  unsigned char,
  void* _Nonnull * _Nullable
);

#endif
