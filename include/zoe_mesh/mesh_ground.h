#ifndef __zoe_zoe_mesh_mesh_ground_h
#define __zoe_zoe_mesh_mesh_ground_h

#include <math_c_vector.h>

#include <metil_mesh/metil_mesh.h>

#define length_vertices_ground_x 0x64
#define length_vertices_ground_y 0x64

extern const struct math_c_vector2_unsigned_int length_vertices_ground;

void mesh_ground_initialize(
  struct metil_mesh*,
  struct math_c_vector3_float*
);

#endif
