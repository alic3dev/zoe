#ifndef __scene_intro_hill_h
#define __scene_intro_hill_h

#include <audio/io_proc_data.h>

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif
#include <MetalKit/MetalKit.h>

#define scene_intro_hill_length_renderables 6

enum scene_intro_hill_index_renderable {
  scene_intro_hill_index_renderable_hill = 0,
  scene_intro_hill_index_renderable_player = 1,
  scene_intro_hill_index_renderable_player_mirror = 2,
  scene_intro_hill_index_renderable_tree_zoe = 3,
  scene_intro_hill_index_renderable_tree_zoe_mirror = 4,
  scene_intro_hill_index_renderable_group_text = 5
};

enum scene_intro_hill_index_renderable_group_text_index_renderable {
  scene_intro_hill_index_renderable_group_text_index_renderable_bounds = 0,
  scene_intro_hill_index_renderable_group_text_index_renderable_tree_hello = 1,
  scene_intro_hill_index_renderable_group_text_index_renderable_tree_not_yours = 2
};

#define scene_intro_hill_length_textures 3

enum scene_intro_hill_textures {
  scene_intro_hill_textures_hill = 0,
  scene_intro_hill_textures_tree = 1,
  scene_intro_hill_textures_player = 2,
  scene_intro_hill_textures_player_mirror = 2
};

struct scene_intro_hill_data {
  struct io_proc_data* _Nonnull io_proc_data;
};

void scene_intro_hill_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_intro_hill_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_intro_hill_destroy(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#if target_os_ios
int scene_intro_hill_io_proc(
  unsigned char,
  const AudioTimeStamp* _Nonnull,
  unsigned int,
  AudioBufferList* _Nonnull,
  void* _Nonnull
);
#else
OSStatus scene_intro_hill_io_proc(
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
