#ifndef __zoe_mesh_mesh_hill_h
#define __zoe_mesh_mesh_hill_h

#include <clic3_vector.h>

#include <metil_mesh/metil_mesh.h>

#define length_vertices_hill_x 1332
#define length_vertices_hill_y 2000

extern const struct clic3_vector2_unsigned_int length_vertices_hill;

void mesh_hill_initialize(
  struct metil_mesh*
);

#endif
