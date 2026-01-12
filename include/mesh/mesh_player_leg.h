#ifndef __mesh_player_leg_h
#define __mesh_player_leg_h

#include <mesh/mesh_player.h>

#ifndef __METAL_VERSION__
#include <metil_mesh/metil_mesh.h>
#endif

#define mesh_player_leg_segments_x 10
#define mesh_player_leg_segments_y 10

#define mesh_player_leg_length_vertices (\
  mesh_player_leg_segments_x *\
  mesh_player_leg_segments_y +\
  2\
)

#define mesh_player_leg_height (\
  mesh_player_height_total /\
  3.5f\
)

#ifndef __METAL_VERSION__
void mesh_player_leg_initialize(
  struct metil_mesh*
);
#endif

#endif
