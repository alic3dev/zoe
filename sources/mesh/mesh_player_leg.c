#include <mesh/mesh_player_leg.h>

#include <math_c_vector.h>

#include <metil_direction.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_mesh/metil_mesh_tube.h>

#include <stdlib.h>

void mesh_player_leg_initialize(
  struct metil_mesh* mesh
) {
  metil_mesh_tube_initialize(
    mesh,
    (struct math_c_vector3_float) {
      .x = 1.0f,
      .y = mesh_player_leg_height,
      .z = 1.0f
    },
    (struct math_c_vector2_unsigned_short_int) {
      .x = 10,
      .y = 10
    },
    metil_direction_down
  );
}
