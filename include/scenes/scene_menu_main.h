#ifndef __scenes_scene_menu_main_h
#define __scenes_scene_menu_main_h

#include <scenes/scene.h>

enum textures_scene_menu_main {
  textures_scene_menu_main_ground = 0,
  textures_scene_menu_main_tree = 1
};

void scene_menu_main_initialize(
  struct scene*,
  id<MTLDevice>
);

#endif
