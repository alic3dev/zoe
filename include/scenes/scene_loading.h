#ifndef __zoe_scenes_scene_loading_h
#define __zoe_scenes_scene_loading_h

#include <zoe_loading_map.h>

#include <metil.h>
#include <metil_scenes/metil_scene.h>

struct data_scene_loading {
  unsigned char id_scene;

  struct zoe_loading_map loading_map;

  struct metil_scene scene;

  void* _Nullable data;
};

void scene_loading_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  unsigned char
);

void scene_loading_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_loading_finished(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  struct data_scene_loading* _Nonnull
);

#endif
