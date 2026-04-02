#ifndef __zoe_mesh_mesh_zoe_body_h
#define __zoe_mesh_mesh_zoe_body_h

#include <metil_mesh/metil_mesh.h>

#define mesh_zoe_body_multiplier_vertex 0x02

#define mesh_zoe_body_length_segments 0x08

#define mesh_zoe_body_length_segments_multiplied (\
  mesh_zoe_body_multiplier_vertex *\
  mesh_zoe_body_length_segments\
)

#define mesh_zoe_body_length_segments_foot mesh_zoe_body_length_segments_multiplied
#define mesh_zoe_body_length_segments_foot_radial mesh_zoe_body_length_segments_multiplied
#define mesh_zoe_body_length_vertices_foot (\
  mesh_zoe_body_length_segments_foot *\
  mesh_zoe_body_length_segments_foot_radial\
)

#define mesh_zoe_body_length_segments_leg mesh_zoe_body_length_segments_multiplied
#define mesh_zoe_body_length_segments_leg_radial mesh_zoe_body_length_segments_multiplied
#define mesh_zoe_body_length_vertices_leg (\
  mesh_zoe_body_length_segments_leg *\
  mesh_zoe_body_length_segments_leg_radial\
)

#define mesh_zoe_body_length_segments_hips (\
  mesh_zoe_body_length_segments /\
  0x02 *\
  mesh_zoe_body_multiplier_vertex\
)
#define mesh_zoe_body_length_segments_hips_radial mesh_zoe_body_length_segments_multiplied
#define mesh_zoe_body_length_vertices_hips (\
  mesh_zoe_body_length_segments_hips *\
  mesh_zoe_body_length_segments_hips_radial\
)

#define mesh_zoe_body_length_segments_waist mesh_zoe_body_length_segments_multiplied
#define mesh_zoe_body_length_segments_waist_radial mesh_zoe_body_length_segments_multiplied

#define mesh_zoe_body_length_vertices_torso (\
  mesh_zoe_body_length_segments_waist *\
  mesh_zoe_body_length_segments_waist_radial\
)

#define mesh_zoe_body_length_segments_upper_arm mesh_zoe_body_length_segments_multiplied
#define mesh_zoe_body_length_segments_upper_arm_radial mesh_zoe_body_length_segments_multiplied
#define mesh_zoe_body_length_vertices_upper_arm (\
  mesh_zoe_body_length_segments_upper_arm *\
  mesh_zoe_body_length_segments_upper_arm_radial\
)

#define mesh_zoe_body_length_segments_forearm mesh_zoe_body_length_segments_multiplied
#define mesh_zoe_body_length_segments_forearm_radial mesh_zoe_body_length_segments_multiplied
#define mesh_zoe_body_length_vertices_forearm (\
  mesh_zoe_body_length_segments_forearm *\
  mesh_zoe_body_length_segments_forearm_radial\
)

#define mesh_zoe_body_length_segments_shoulder (\
  mesh_zoe_body_length_segments /\
  0x06 *\
  mesh_zoe_body_multiplier_vertex\
)
#define mesh_zoe_body_length_segments_shoulder_radial mesh_zoe_body_length_segments_multiplied
#define mesh_zoe_body_length_vertices_shoulder (\
  mesh_zoe_body_length_segments_shoulder *\
  mesh_zoe_body_length_segments_shoulder_radial\
)

#define mesh_zoe_body_length_vertices_arm (\
  mesh_zoe_body_length_vertices_upper_arm *\
  mesh_zoe_body_length_vertices_forearm\
)

#define mesh_zoe_body_length_vertices (\
  mesh_zoe_body_length_vertices_leg *\
  0x02 +\
  mesh_zoe_body_length_vertices_hips +\
  mesh_zoe_body_length_vertices_torso +\
  (\
    mesh_zoe_body_length_vertices_shoulder +\
    mesh_zoe_body_length_vertices_arm\
  ) *\
  0x02\
)
void mesh_zoe_body_initialize(
  struct metil_mesh*
);

#endif
