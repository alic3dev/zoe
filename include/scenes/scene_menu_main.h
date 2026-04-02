#ifndef __zoe_scenes_scene_menu_main_h
#define __zoe_scenes_scene_menu_main_h

#include <audio/io_proc_data.h>

#include <metil_menus/metil_menu.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/metil_scene.h>

#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif
#include <MetalKit/MetalKit.h>

extern const unsigned long int scene_menu_main_time_scene_transition;

enum textures_scene_menu_main {
  textures_scene_menu_main_ground = 0,
  textures_scene_menu_main_tree = 1,
  textures_scene_menu_main_title = 2,
  textures_scene_menu_main_menu_enter = 3,
  textures_scene_menu_main_menu_exit = 4
};

struct scene_menu_main_data {
  struct metil_menu menu;
  unsigned long int time_started;

  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  struct io_proc_data* _Nonnull io_proc_data;
};

void scene_menu_main_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_menu_main_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_menu_main_poll_input(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_menu_main_destroy(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#if target_os_ios
int scene_menu_main_io_proc(
  unsigned char,
  const AudioTimeStamp* _Nonnull,
  unsigned int,
  AudioBufferList* _Nonnull,
  void* _Nonnull
);
#else
OSStatus scene_menu_main_io_proc(
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
