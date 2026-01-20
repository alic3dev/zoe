#ifndef __zoe_mesh_mesh_player_h
#define __zoe_mesh_mesh_player_h

#include <math_c_vector.h>

#ifndef __METAL_VERSION__
#include <metil_mesh/metil_mesh.h>
#endif

#define mesh_player_body_length_vertices 14

#define mesh_player_height_total 15.0f

#define mesh_player_colour_r 0.01f
#define mesh_player_colour_g 0.009f
#define mesh_player_colour_b 0.02f
#define mesh_player_colour_a 1.0f

#ifndef __METAL_VERSION__
extern const struct math_c_vector3_float mesh_player_size;
extern const struct math_c_vector3_float mesh_player_size_half;

void mesh_player_initialize(
  struct metil_mesh*
);
#endif

#endif
