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
    mesh_player_head_diameter,
    (struct math_c_vector2_unsigned_short_int) {
      .x = mesh_player_head_segments_x,
      .y = mesh_player_head_segments_y
    }
  );
}
