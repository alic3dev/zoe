#include <mesh/tree/mesh_tree.h>

#include <mesh/mesh.h>

#include <clic3.h>

#include <math.h>
#include <stdlib.h>
#include <stdio.h>

void mesh_tree_initialize(
  struct mesh* mesh,
  float radius,
  float height
) {
  mesh_initialize(mesh);

  mesh->size.x = radius * 2.0f;
  mesh->size.y = height;
  mesh->size.z = mesh->size.x;

  unsigned char length_segments_height = 10;
  unsigned char length_vertices_radius = 10;

  float interval_height = height / (float)length_segments_height;

  mesh->length_vertices = (
    length_segments_height * length_vertices_radius
  );

  mesh->length_indices = (
    (
      (length_segments_height - 1) * 
      (length_vertices_radius )
    ) * 6
  );

  mesh->vertices = realloc(
    mesh->vertices,
    sizeof(struct clic3_vector4_float) *
    mesh->length_vertices
  );

  mesh->indices = realloc(
    mesh->indices,
    sizeof(unsigned int) *
    mesh->length_indices
  );

  float radius_tenth = radius / 10.0f;
  float radius_nine_tenths = radius / 10.0f * 9.0f;

  unsigned int index_index = 0;

  for (
    unsigned char index_segment_height = 0;
    index_segment_height < length_segments_height;
    ++index_segment_height
  ) {
    unsigned int index_offset_height = (
      index_segment_height * length_vertices_radius
    );

    for (
      unsigned char index_segment_radius = 0;
      index_segment_radius < length_vertices_radius;
      ++index_segment_radius
    ) {
      unsigned int index_vertex = (
        index_offset_height + index_segment_radius
      );

      float distance = fmod(((float) rand()) / 1000.0f, radius_nine_tenths) + radius_tenth;
      float angle = (float)index_segment_radius / (float)length_vertices_radius * M_PI * 2.0f;
      
      mesh->vertices[index_vertex].x = cos(angle) * distance;
      mesh->vertices[index_vertex].y = index_segment_height * interval_height;
      mesh->vertices[index_vertex].z = sin(angle) * distance;
      mesh->vertices[index_vertex].w = 1.0f;

      if (
        index_segment_height >= length_segments_height - 1
      ) {
        continue;
      }

      if (
        index_segment_radius + 1 < length_vertices_radius
      ) {
        mesh->indices[index_index++] = index_vertex;
        mesh->indices[index_index++] = index_vertex + 1;
        mesh->indices[index_index++] = index_vertex + length_vertices_radius;

        mesh->indices[index_index++] = index_vertex + 1;
        mesh->indices[index_index++] = index_vertex + length_vertices_radius;
        mesh->indices[index_index++] = index_vertex + length_vertices_radius + 1;
      } else {
        mesh->indices[index_index++] = index_vertex;
        mesh->indices[index_index++] = (index_vertex + 1) - length_vertices_radius;
        mesh->indices[index_index++] = index_vertex + length_vertices_radius;

        mesh->indices[index_index++] = index_vertex + 1;
        mesh->indices[index_index++] = (index_vertex + 1) - length_vertices_radius;
        mesh->indices[index_index++] = index_vertex + length_vertices_radius;
      }
    }
  }

  // 0 1 8
  // 1 8 9

  // 1 2 9
  // 1 9 10

  // 7 0 8
  // 7 8 15

  //    8 9
  // 15     10
  //  14     11
  //    13 12

  //    0 1
  //  7     2
  //   6     3
  //     5 4
}
