#include <mesh/mesh_player_arm.h>

#include <math_c_vector.h>

#include <metil_direction.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_mesh/metil_mesh_tube.h>

#include <stdlib.h>

void mesh_player_arm_initialize(
  struct metil_mesh* mesh,
  enum metil_direction metil_direction
) {
  metil_mesh_tube_initialize(
    mesh,
    (struct math_c_vector3_float) {
      .x = mesh_player_arm_length,
      .y = 0.6,
      .z = 0.6f
    },
    (struct math_c_vector2_unsigned_short_int) {
      .x = 10,
      .y = 10
    },
    metil_direction
  );
}
