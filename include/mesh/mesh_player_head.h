#ifndef __mesh_player_head_h
#define __mesh_player_head_h

#include <mesh/mesh_player.h>

#ifndef __METAL_VERSION__
#include <metil_mesh/metil_mesh.h>
#endif

#define mesh_player_head_diameter (\
  mesh_player_height_total /\
  3.0f\
)

#define mesh_player_head_segments_x 10
#define mesh_player_head_segments_y 10

#define mesh_player_head_segments_total (\
  mesh_player_head_segments_x *\
  mesh_player_head_segments_y +\
  2\
)

#define mesh_player_head_segments_half (\
  mesh_player_head_segments_total /\
  2\
)

#ifndef __METAL_VERSION__
void mesh_player_head_initialize(
  struct metil_mesh*
);
#endif

#endif
