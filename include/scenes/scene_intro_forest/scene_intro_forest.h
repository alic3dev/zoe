#ifndef __zoe_scenes_scene_intro_forest_scene_intro_forest_h
#define __zoe_scenes_scene_intro_forest_scene_intro_forest_h

#include <audio/io_proc_data.h>

#include <metil_scenes/metil_scene.h>
#include <metil_rendering/metil_renderer_interface.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif
#include <MetalKit/MetalKit.h>

#define scene_intro_forest_length_renderables 4
#define scene_intro_forest_length_group_trees_renderables 1000

enum scene_intro_forest_index_renderable {
  scene_intro_forest_index_renderable_ground = 0,
  scene_intro_forest_index_renderable_player = 1,
  scene_intro_forest_index_renderable_player_mirror = 2,
  scene_intro_forest_index_renderable_group_trees = 3,
};

enum textures_scene_intro_forest {
  textures_scene_intro_forest_ground = 0,
  textures_scene_intro_forest_tree = 1,
  textures_scene_intro_forest_player = 2
};

struct scene_intro_forest_data {
  struct io_proc_data* _Nonnull io_proc_data;
};

void scene_intro_forest_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull,
  float* _Nonnull
);

void scene_intro_forest_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_intro_forest_destroy(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#if target_os_ios
int scene_intro_forest_io_proc(
  unsigned char,
  const AudioTimeStamp* _Nonnull,
  unsigned int,
  AudioBufferList* _Nonnull,
  void* _Nonnull
);
#else
OSStatus scene_intro_forest_io_proc(
  AudioObjectID,
  const AudioTimeStamp* _Nonnull,
  const AudioBufferList* _Nonnull,
  const AudioTimeStamp* _Nonnull,
  AudioBufferList* _Nonnull,
  const AudioTimeStamp* _Nonnull,
  void* _Nonnull
);
#endif

#endif
