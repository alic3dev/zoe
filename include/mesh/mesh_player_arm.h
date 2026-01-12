#ifndef __mesh_player_arm_h
#define __mesh_player_arm_h

#include <mesh/mesh_player.h>

#include <metil_direction.h>
#ifndef __METAL_VERSION__
#include <metil_mesh/metil_mesh.h>
#endif

#define mesh_player_arm_length (\
  mesh_player_height_total /\
  3.5f\
)

#ifndef __METAL_VERSION__
void mesh_player_arm_initialize(
  struct metil_mesh*,
  enum metil_direction
);
#endif

#endif
