#ifndef __zoe_mesh_mesh_player_h
#define __zoe_mesh_mesh_player_h

#include <math_c_vector.h>

#include <metil_mesh/metil_mesh.h>

extern const struct math_c_vector3_float mesh_player_size;
extern const struct math_c_vector3_float mesh_player_size_half;

void mesh_player_initialize(
  struct metil_mesh*
);

#endif
