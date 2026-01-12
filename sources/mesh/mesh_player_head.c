#include <mesh/mesh_player_head.h>

#include <math_c_vector.h>

#include <metil_mesh/metil_mesh.h>
#include <metil_mesh/metil_mesh_ball.h>

#include <stdlib.h>

void mesh_player_head_initialize(
  struct metil_mesh* mesh
) {
  metil_mesh_ball_initialize(
    mesh,
    5.0f,
    (struct math_c_vector2_unsigned_short_int) {
      .x = 10,
      .y = 10
    }
  );
}
