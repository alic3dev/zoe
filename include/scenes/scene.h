#ifndef __scenes_scene_h
#define __scenes_scene_h

#include <player.h>

enum scene_type {
  beginning
};

struct scene {
  struct player player;
  enum scene_type type;

  unsigned char loading;
};

void scene_initialize(
  struct scene*
);

void scene_input_poll(
  struct scene*
);

void scene_poll(
  struct scene*
);

void scene_destroy(
  struct scene*
);

#endif
