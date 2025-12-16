#ifndef __zoe_mesh_mesh_tree_h
#define __zoe_mesh_mesh_tree_h

#include <clic3_vector.h>

#include <metil_mesh/mesh.h>

#define zoe_mesh_tree_length_segments_height 10
#define zoe_mesh_tree_length_vertices_radius 10
#define zoe_mesh_tree_length_vertices_trunk zoe_mesh_tree_length_segments_height * zoe_mesh_tree_length_vertices_radius

void mesh_tree_initialize(
  struct metil_mesh* _Nonnull,
  struct clic3_vector2_float* _Nonnull
);

#endif
