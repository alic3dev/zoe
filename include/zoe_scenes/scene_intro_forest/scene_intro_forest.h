#ifndef __zoe_scenes_scene_intro_forest_scene_intro_forest_h
#define __zoe_scenes_scene_intro_forest_scene_intro_forest_h

#include <zoe_audio/io_proc_data.h>
#include <zoe_enemies/zoe_enemy_controller.h>
#include <zoe_loading_threads.h>

#include <metil_group.h>
#include <metil_scenes/metil_scene.h>
#include <metil_rendering/metil_renderer_interface.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif
#include <MetalKit/MetalKit.h>

#define scene_intro_forest_length_renderables 0x08
#define scene_intro_forest_length_group_trees_renderables 1000

enum scene_intro_forest_index_renderable {
  scene_intro_forest_index_renderable_ground           = 0x00,
  scene_intro_forest_index_renderable_player           = 0x01,
  scene_intro_forest_index_renderable_player_mirror    = 0x02,
  scene_intro_forest_index_renderable_group_enemies    = 0x03,
  scene_intro_forest_index_renderable_group_trees      = 0x04,
  scene_intro_forest_index_renderable_group_text_place = 0x05,
  scene_intro_forest_index_renderable_group_text_used  = 0x06,
  scene_intro_forest_index_renderable_group_text_this  = 0x07
};

enum textures_scene_intro_forest {
  textures_scene_intro_forest_ground = 0x00,
  textures_scene_intro_forest_tree   = 0x01,
  textures_scene_intro_forest_player = 0x02
};

struct scene_intro_forest_data {
  struct io_proc_data* _Nonnull io_proc_data;

  struct zoe_enemy_controller enemy_controller;

  unsigned char index_text;
};

struct scene_intro_forest_tree_thread_data {
  struct metil_group* _Nonnull group;
  struct math_c_vector3_float* _Nonnull size_bounds;
  unsigned int offset;
  unsigned int length;
};

void scene_intro_forest_initialize(
  struct zoe_loading_threads_data* _Nonnull
);

void zoe_scene_intro_forest_threaded_trees_initialization(
  struct zoe_loading_threads_data* _Nonnull
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
