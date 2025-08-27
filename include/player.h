#ifndef __player_h
#define __player_h

#include <clic3.h>

struct player {
  struct clic3_vector3_float position;
  struct clic3_vector3_float rotation;
  struct clic3_vector3_float velocity;

  float speed_movement;
  float speed_rotation;
};

void player_initialize(
  struct player*
);

void player_input_poll(
  struct player*
);

void player_poll(
  struct player*
);

void player_destroy(
  struct player*
);

#endif
