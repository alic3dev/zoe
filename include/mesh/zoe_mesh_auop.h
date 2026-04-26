#ifndef __zoe_mesh_zoe_mesh_auop_h
#define __zoe_mesh_zoe_mesh_auop_h

#include <metil_mesh/metil_mesh.h>

#define zoe_mesh_auop_length_segments 0x10
#define zoe_mesh_auop_length_segment_vertices_radial 0x10

#define zoe_mesh_auop_length_vertices (\
  zoe_mesh_auop_length_segments *\
  zoe_mesh_auop_length_segment_vertices_radial +\
  0x01\
)

#define zoe_mesh_auop_length_indices (\
  zoe_mesh_auop_length_vertices *\
  0x03\
)

#define zoe_mesh_auop_height 0x08

void zoe_mesh_auop_initialize(
  struct metil_mesh*
);

#endif
