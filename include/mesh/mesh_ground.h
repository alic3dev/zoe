#ifndef __zoe_mesh_mesh_ground_h
#define __zoe_mesh_mesh_ground_h

#include <clic3_vector.h>

#include <metil_mesh/mesh.h>

#define length_vertices_ground_x 100
#define length_vertices_ground_y 100

extern const struct clic3_vector2_unsigned_int length_vertices_ground;

void mesh_ground_initialize(
  struct metil_mesh*,
  struct clic3_vector3_float*
);

#endif
