#ifndef __zoe_zoe_mesh_mesh_zoe_body_h
#define __zoe_zoe_mesh_mesh_zoe_body_h

#include <metil_mesh/metil_mesh.h>

#define mesh_zoe_body_multiplier_vertex 0x02

#define mesh_zoe_body_length_segments 0x0a

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
  mesh_zoe_body_length_vertices_upper_arm +\
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

#define mesh_zoe_body_index_vertex_leg_right_start 0x00
#define mesh_zoe_body_index_vertex_leg_right_end mesh_zoe_body_length_vertices_leg

#define mesh_zoe_body_index_vertex_calf_right_start mesh_zoe_body_index_vertex_leg_right_start
#define mesh_zoe_body_index_vertex_calf_right_end (\
  mesh_zoe_body_index_vertex_calf_right_start +\
  (\
    mesh_zoe_body_length_vertices_leg /\
    0x02\
  )\
)

#define mesh_zoe_body_index_vertex_thigh_right_start mesh_zoe_body_index_vertex_calf_right_end
#define mesh_zoe_body_index_vertex_thigh_right_end (\
  mesh_zoe_body_index_vertex_thigh_right_start +\
  (\
    mesh_zoe_body_length_vertices_leg /\
    0x02\
  )\
)

#define mesh_zoe_body_index_vertex_leg_left_start mesh_zoe_body_index_vertex_leg_right_end
#define mesh_zoe_body_index_vertex_leg_left_end (\
  mesh_zoe_body_index_vertex_leg_left_start +\
  mesh_zoe_body_length_vertices_leg\
)

#define mesh_zoe_body_index_vertex_calf_left_start mesh_zoe_body_index_vertex_leg_left_start
#define mesh_zoe_body_index_vertex_calf_left_end (\
  mesh_zoe_body_index_vertex_calf_left_start +\
  (\
    mesh_zoe_body_length_vertices_leg /\
    0x02\
  )\
)

#define mesh_zoe_body_index_vertex_thigh_left_start mesh_zoe_body_index_vertex_calf_left_end
#define mesh_zoe_body_index_vertex_thigh_left_end (\
  mesh_zoe_body_index_vertex_thigh_left_start +\
  (\
    mesh_zoe_body_length_vertices_leg /\
    0x02\
  )\
)

#define mesh_zoe_body_index_vertex_hips_start mesh_zoe_body_index_vertex_leg_left_end
#define mesh_zoe_body_index_vertex_hips_end (\
  mesh_zoe_body_index_vertex_hips_start +\
  mesh_zoe_body_length_vertices_hips\
)

#define mesh_zoe_body_index_vertex_torso_start mesh_zoe_body_index_vertex_hips_end
#define mesh_zoe_body_index_vertex_torso_end (\
  mesh_zoe_body_index_vertex_torso_start +\
  mesh_zoe_body_length_vertices_torso\
)

#define mesh_zoe_body_index_vertex_arm_left_start mesh_zoe_body_index_vertex_torso_end
#define mesh_zoe_body_index_vertex_arm_left_end (\
  mesh_zoe_body_index_vertex_arm_left_start +\
  mesh_zoe_body_length_vertices_arm +\
  mesh_zoe_body_length_vertices_shoulder\
)

#define mesh_zoe_body_index_vertex_upper_arm_left_start mesh_zoe_body_index_vertex_arm_left_start
#define mesh_zoe_body_index_vertex_upper_arm_left_end (\
  mesh_zoe_body_index_vertex_upper_arm_left_start +\
  mesh_zoe_body_length_vertices_forearm +\
  mesh_zoe_body_length_vertices_shoulder\
)

#define mesh_zoe_body_index_vertex_forearm_left_start mesh_zoe_body_index_vertex_upper_arm_left_end
#define mesh_zoe_body_index_vertex_forearm_left_end (\
  mesh_zoe_body_index_vertex_forearm_left_start +\
  mesh_zoe_body_length_vertices_upper_arm\
)

#define mesh_zoe_body_index_vertex_arm_right_start mesh_zoe_body_index_vertex_arm_left_end
#define mesh_zoe_body_index_vertex_arm_right_end (\
  mesh_zoe_body_index_vertex_arm_right_end +\
  mesh_zoe_body_length_vertices_arm +\
  mesh_zoe_body_length_vertices_shoulder\
)

#define mesh_zoe_body_index_vertex_upper_arm_right_start mesh_zoe_body_index_vertex_arm_right_start
#define mesh_zoe_body_index_vertex_upper_arm_right_end (\
  mesh_zoe_body_index_vertex_upper_arm_right_start +\
  mesh_zoe_body_length_vertices_upper_arm +\
  mesh_zoe_body_length_vertices_shoulder\
)

#define mesh_zoe_body_index_vertex_forearm_right_start mesh_zoe_body_index_vertex_upper_arm_right_end
#define mesh_zoe_body_index_vertex_forearm_right_end (\
  mesh_zoe_body_index_vertex_forearm_right_start +\
  mesh_zoe_body_length_vertices_forearm\
)

void mesh_zoe_body_initialize(
  struct metil_mesh*
);

#endif
