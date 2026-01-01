#ifndef __zoe_mesh_mesh_player_h
#define __zoe_mesh_mesh_player_h

#include <clic3_vector.h>

#include <metil_mesh/metil_mesh.h>

extern const struct clic3_vector3_float mesh_player_size;
extern const struct clic3_vector3_float mesh_player_size_half;

void mesh_player_initialize(
  struct metil_mesh*
);

#endif
