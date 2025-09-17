#include <mesh/tree/mesh_tree.h>

#include <clic3.h>

#include <metil_mesh/mesh.h>

#include <math.h>
#include <stdlib.h>

void mesh_tree_initialize(
  struct metil_mesh* mesh,
  float radius,
  float height
) {
  metil_mesh_initialize(mesh);

  mesh->size.x = radius * 2.0f;
  mesh->size.y = height;
  mesh->size.z = mesh->size.x;

  unsigned char length_segments_height = 10;
  unsigned char length_vertices_radius = 10;

  float interval_height = height / (float) (length_segments_height - 1);

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
  float radius_nine_tenths = radius_tenth * 9.0f;

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

  unsigned char count_branches = (rand() % 30) + 10;

  float radius_branch_tenth = (radius / 2.0f) / 10.0f;
  float radius_branch_nine_tenths = radius_branch_nine_tenths * 9.0f;

  unsigned char length_vertices_radius_branch = length_vertices_radius / 2;

  if (length_vertices_radius_branch % 2 != 0) {
    length_vertices_radius_branch = (
      length_vertices_radius_branch + 1
    );
  }

  for (
    unsigned char index_branch = 0;
    index_branch < count_branches;
    ++index_branch
  ) {
    unsigned int index_vertex = (
      mesh->length_vertices
    );

    unsigned char joints_branch = rand() % 10 + 5;

    mesh->length_vertices = (
      mesh->length_vertices + 
      (joints_branch * 4)
    );

    mesh->length_indices = (
      mesh->length_indices + 
      (joints_branch * 6) 
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

    float angle = (
      ((float)(rand() % 10000) / 10000.0f) *
      M_PI * 2.0f
    );

    struct clic3_vector3_float position_joint_branch = {
      .x = 0.0f,
      .y = ((float)(rand() % 10000) / 20000.0f) * mesh->size.y + (mesh->size.y / 2.0f),
      .z = 0.0f
    };

    for (
      unsigned char index_joint_branch = 0;
      index_joint_branch < joints_branch;
      ++index_joint_branch
    ) {
      float distance = fmod(((float) rand()) / 1000.0f, radius_branch_nine_tenths) + radius_branch_tenth;
      float length = ((float)(rand() % 10000) / 10000.0f) * (mesh->size.y / 5.0f) + (mesh->size.y / 5.0f);
      
      if (index_joint_branch == 0 ) {

        mesh->vertices[index_vertex].x = position_joint_branch.x;
        mesh->vertices[index_vertex].y = position_joint_branch.y;
        mesh->vertices[index_vertex].z = position_joint_branch.z;
        mesh->vertices[index_vertex].w = 1.0f;

        position_joint_branch.y = (
          position_joint_branch.y + (
            ((((float)(rand() % 10000)) / 10000.0f) - 0.125f) * (mesh->size.y / 20.0f) + (mesh->size.y / 20.0f)
          )
        );

        mesh->vertices[index_vertex + 1].x = position_joint_branch.x;
        mesh->vertices[index_vertex + 1].y = position_joint_branch.y;
        mesh->vertices[index_vertex + 1].z = position_joint_branch.z;
        mesh->vertices[index_vertex + 1].w = 1.0f;
      } else {
        position_joint_branch.x = mesh->vertices[index_vertex - 2].x;
        position_joint_branch.y = mesh->vertices[index_vertex - 2].y;
        position_joint_branch.z = mesh->vertices[index_vertex - 2].z;

        mesh->vertices[index_vertex].x = position_joint_branch.x;
        mesh->vertices[index_vertex].y = position_joint_branch.y;
        mesh->vertices[index_vertex].z = position_joint_branch.z;
        mesh->vertices[index_vertex].w = 1.0f;

        position_joint_branch.x = mesh->vertices[index_vertex - 1].x;
        position_joint_branch.y = mesh->vertices[index_vertex - 1].y;
        position_joint_branch.z = mesh->vertices[index_vertex - 1].z;

        mesh->vertices[index_vertex + 1].x = position_joint_branch.x;
        mesh->vertices[index_vertex + 1].y = position_joint_branch.y;
        mesh->vertices[index_vertex + 1].z = position_joint_branch.z;
        mesh->vertices[index_vertex + 1].w = 1.0f;
      }

      if (index_joint_branch != 0) {
        position_joint_branch.y = (
          position_joint_branch.y + (
            ((((float)(rand() % 10000)) / 10000.0f) - 0.125f) * (mesh->size.y / 30.0f) + (mesh->size.y / 30.0f)
          )
        );
      } 

      position_joint_branch.x = (
        cosf(angle) * (length * ((float)(index_joint_branch + 1) / ((float)(joints_branch))))
      );

      position_joint_branch.z = (
        sinf(angle) * (length * ((float)(index_joint_branch + 1) / ((float)(joints_branch))))
      );

      mesh->vertices[index_vertex + 2].x = position_joint_branch.x;
      mesh->vertices[index_vertex + 2].y = position_joint_branch.y;
      mesh->vertices[index_vertex + 2].z = position_joint_branch.z;
      mesh->vertices[index_vertex + 2].w = 1.0f;

      position_joint_branch.y = (
        position_joint_branch.y + (
          ((((float)(rand() % 10000)) / 10000.0f) - 0.125f) * (mesh->size.y / 30.0f) + (mesh->size.y / 30.0f)
        )
      );

      mesh->vertices[index_vertex + 3].x = position_joint_branch.x;
      mesh->vertices[index_vertex + 3].y = position_joint_branch.y;
      mesh->vertices[index_vertex + 3].z = position_joint_branch.z;
      mesh->vertices[index_vertex + 3].w = 1.0f;

      mesh->indices[index_index++] = index_vertex;
      mesh->indices[index_index++] = index_vertex + 1;
      mesh->indices[index_index++] = index_vertex + 2;

      mesh->indices[index_index++] = index_vertex + 3;
      mesh->indices[index_index++] = index_vertex + 2;
      mesh->indices[index_index++] = index_vertex;
 
      index_vertex = (
        index_vertex + 4
      );
    }
  }
}
