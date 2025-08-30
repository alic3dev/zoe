#ifndef __scenes_scene_menu_main_h
#define __scenes_scene_menu_main_h

#include <menus/menu.h>
#include <scenes/scene.h>

#include <CoreAudio/CoreAudio.h>

enum textures_scene_menu_main {
  textures_scene_menu_main_ground = 0,
  textures_scene_menu_main_tree = 1
};

struct scene_menu_main_data {
  struct menu menu;
  unsigned char menu_closing;
};

void scene_menu_main_initialize(
  struct scene*,
  id<MTLDevice>
);

void scene_menu_main_poll(
  struct scene*
);

void scene_menu_main_poll_input(
  struct scene*
);

void scene_menu_main_destroy(
  struct scene*
);

void menu_print(
  struct menu*
);

OSStatus scene_menu_main_io_proc(
  AudioObjectID,
  const AudioTimeStamp*,
  const AudioBufferList*,
  const AudioTimeStamp*,
  AudioBufferList*,
  const AudioTimeStamp*,
  void*
);

#endif
