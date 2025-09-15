#include <mesh/mesh_player.h>

#include <mesh/mesh.h>

#include <clic3_vector.h>

#include <math.h>
#include <stdlib.h>
#include <stdio.h>

const struct clic3_vector3_float mesh_player_size = {
  .x = 10.0f,
  .y = 5.0f,
  .z = 10.0f
};

const struct clic3_vector3_float mesh_player_size_half = {
  .x = mesh_player_size.x / 2.0f,
  .y = mesh_player_size.y / 2.0f,
  .z = mesh_player_size.z / 2.0f
};

const struct clic3_vector3_float mesh_player_size_quarter = {
  .x = 0,//mesh_player_size_half.x / 2.0f,
  .y = 0,//mesh_player_size_half.y / 2.0f,
  .z = 0//mesh_player_size_half.z / 2.0f
};

void mesh_player_initialize(
  struct mesh* mesh
) {
  mesh_initialize(mesh);

  mesh->size.x = mesh_player_size.x;
  mesh->size.y = mesh_player_size.y;
  mesh->size.z = mesh_player_size.z;

  mesh->length_vertices = 14;
  mesh->length_indices = (
    (mesh->length_vertices - 1) * 3
  );

  mesh->positioning = mesh_positioning_player;

  mesh->indices = realloc(
    mesh->indices,
    sizeof(unsigned int) *
    mesh->length_indices
  );

  mesh->vertices = realloc(
    mesh->vertices,
    sizeof(struct clic3_vector4_float) *
    mesh->length_vertices
  );

  mesh->vertices[0].x = 0;
  mesh->vertices[0].y = mesh_player_size.y;
  mesh->vertices[0].z = 0;
  mesh->vertices[0].w = 1.0f;

  for (
    unsigned char index_vertex = 1;
    index_vertex < mesh->length_vertices;
    ++index_vertex
  ) {
    float angle = (
      ((float) (index_vertex - 1)) /
      ((float) (mesh->length_vertices - 2)) *
      M_PI * 2.0f
    );
    
    mesh->vertices[index_vertex].x = cos(angle) * mesh_player_size_half.x;
    mesh->vertices[index_vertex].y = 0;
    mesh->vertices[index_vertex].z = sin(angle) * mesh_player_size_half.x;
    mesh->vertices[index_vertex].w = 1.0f;
  }

  for (
    unsigned char index_index = 0;
    index_index < mesh->length_indices / 3;
    ++index_index
  ) {
    mesh->indices[index_index * 3] = 0;
    mesh->indices[index_index * 3 + 1] = index_index;
    mesh->indices[index_index * 3 + 2] = index_index + 1;

  }

  // mesh->vertices[0].x = -mesh_player_size_half.x;
  // mesh->vertices[0].y = 0.0f;
  // mesh->vertices[0].z = -mesh_player_size_half.z;
  // mesh->vertices[0].w = 1.0f;

  // mesh->vertices[1].x = mesh_player_size_half.x;
  // mesh->vertices[1].y = 0.0f;
  // mesh->vertices[1].z = -mesh_player_size_half.z;
  // mesh->vertices[1].w = 1.0f;

  // mesh->vertices[2].x = mesh_player_size_half.x;
  // mesh->vertices[2].y = 0.0f;
  // mesh->vertices[2].z = mesh_player_size_half.z;
  // mesh->vertices[2].w = 1.0f;

  // mesh->vertices[3].x = -mesh_player_size_half.x;
  // mesh->vertices[3].y = 0.0f;
  // mesh->vertices[3].z = mesh_player_size_half.z;
  // mesh->vertices[3].w = 1.0f;

  // mesh->vertices[4].x = -mesh_player_size_quarter.x;
  // mesh->vertices[4].y = mesh_player_size.y;
  // mesh->vertices[4].z = -mesh_player_size_quarter.z;
  // mesh->vertices[4].w = 1.0f;

  // mesh->vertices[5].x = mesh_player_size_quarter.x;
  // mesh->vertices[5].y = mesh_player_size.y;
  // mesh->vertices[5].z = -mesh_player_size_quarter.z;
  // mesh->vertices[5].w = 1.0f;

  // mesh->vertices[6].x = mesh_player_size_quarter.x;
  // mesh->vertices[6].y = mesh_player_size.y;
  // mesh->vertices[6].z = mesh_player_size_quarter.z;
  // mesh->vertices[6].w = 1.0f;

  // mesh->vertices[7].x = -mesh_player_size_quarter.x;
  // mesh->vertices[7].y = mesh_player_size.y;
  // mesh->vertices[7].z = mesh_player_size_quarter.z;
  // mesh->vertices[7].w = 1.0f;

  // mesh->indices[0] = 0;
  // mesh->indices[1] = 1;
  // mesh->indices[2] = 3;
  // mesh->indices[3] = 3;
  // mesh->indices[4] = 2;
  // mesh->indices[5] = 1;
  // mesh->indices[6] = 1;
  // mesh->indices[7] = 0;
  // mesh->indices[8] = 4;
  // mesh->indices[9] = 4;
  // mesh->indices[10] = 5;
  // mesh->indices[11] = 1;
  // mesh->indices[12] = 1;
  // mesh->indices[13] = 2;
  // mesh->indices[14] = 5;
  // mesh->indices[15] = 5;
  // mesh->indices[16] = 6;
  // mesh->indices[17] = 2;
  // mesh->indices[18] = 2;
  // mesh->indices[19] = 3;
  // mesh->indices[20] = 6;
  // mesh->indices[21] = 6;
  // mesh->indices[22] = 7;
  // mesh->indices[23] = 3;
  // mesh->indices[24] = 3;
  // mesh->indices[25] = 0;
  // mesh->indices[26] = 7;
  // mesh->indices[27] = 7;
  // mesh->indices[28] = 0;
  // mesh->indices[29] = 4;
  // mesh->indices[30] = 4;
  // mesh->indices[31] = 5;
  // mesh->indices[32] = 7;
  // mesh->indices[33] = 7;
  // mesh->indices[34] = 6;
  // mesh->indices[35] = 5;
}
