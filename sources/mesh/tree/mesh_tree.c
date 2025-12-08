#include <mesh/tree/mesh_tree.h>

#include <clic3.h>

#include <metil_mesh/mesh.h>

#include <rand_functions.h>
#include <rand_initialize.h>
#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>
#include <rand_source_type.h>

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

  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  rand_initialize(
    &rand_parameters,
    &rand_result,
    &rand_source, (
      length_segments_height *
      length_vertices_radius *
      2 +
      1
    ),
    rand_mode_bytes,
    rand_source_type_divisive
  );

  rand_get(
    &rand_source,
    &rand_result,
    &rand_parameters
  );

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

      float distance = fmod(((float) (
        rand_result.bytes[index_vertex + 1] *
        rand_result.bytes[index_vertex + 2]
      )) / 1000.0f, radius_nine_tenths) + radius_tenth;

      float angle = (
        (float)index_segment_radius /
        (float)length_vertices_radius *
        M_PI *
        2.0f
      );
      
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

  unsigned char count_branches = (
    rand_result.bytes[0] % 50
  ) + 50;

  float radius_branch_tenth = (radius / 2.0f) / 10.0f;
  float radius_branch_nine_tenths = radius_branch_nine_tenths * 9.0f;

  unsigned char length_vertices_radius_branch = length_vertices_radius / 2;

  if (length_vertices_radius_branch % 2 != 0) {
    length_vertices_radius_branch = (
      length_vertices_radius_branch + 1
    );
  }

  struct rand_parameters rand_parameters_secondary;
  struct rand_source rand_source_secondary;
  struct rand_result rand_result_secondary;

  rand_initialize(
    &rand_parameters_secondary,
    &rand_result_secondary,
    &rand_source_secondary, (
      count_branches *
      155
    ),
    rand_mode_bytes,
    rand_source_type_divisive
  );

  rand_get(
    &rand_source_secondary,
    &rand_result_secondary,
    &rand_parameters_secondary
  );

  for (
    unsigned char index_branch = 0;
    index_branch < count_branches;
    ++index_branch
  ) {
    unsigned int offset_byte = (
      index_branch * 155
    );

    unsigned int index_vertex = (
      mesh->length_vertices
    );

    unsigned char joints_branch = (
      rand_result_secondary.bytes[offset_byte + 10] % 10
    ) + 5;

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
      ((float)((
        rand_result_secondary.bytes[offset_byte + 3] *
        rand_result_secondary.bytes[offset_byte + 4]
      ) % 10000) / 10000.0f) *
      M_PI * 2.0f
    );

    struct clic3_vector3_float position_joint_branch = {
      .x = 0.0f,
      .y = mesh->size.y - (((float)((
        rand_result_secondary.bytes[offset_byte + 2] *
        rand_result_secondary.bytes[offset_byte + 1]
      ) % 10000) / 20000.0f) * mesh->size.y),
      .z = 0.0f
    };

    for (
      unsigned char index_joint_branch = 0;
      index_joint_branch < joints_branch;
      ++index_joint_branch
    ) {
      float distance = fmod(
        (float) (
          rand_result_secondary.bytes[offset_byte + 5] *
          rand_result_secondary.bytes[offset_byte + 7]
        ) / 1000.0f,
        radius_branch_nine_tenths
      ) + radius_branch_tenth;

      float length = (
        ((float)((
          rand_result_secondary.bytes[offset_byte + 11] *
          rand_result_secondary.bytes[offset_byte]
        ) % 10000) / 10000.0f) *
        (mesh->size.y / 5.0f) +
        (mesh->size.y / 5.0f)
      );
      
      mesh->vertices[index_vertex].x = position_joint_branch.x;
      mesh->vertices[index_vertex].y = position_joint_branch.y;
      mesh->vertices[index_vertex].z = position_joint_branch.z;
      mesh->vertices[index_vertex].w = 1.0f;

      position_joint_branch.y = (
        position_joint_branch.y + (
          ((((float)((
            rand_result_secondary.bytes[offset_byte + 13] *
            rand_result_secondary.bytes[offset_byte + 9]
          ) % 10000)) / 5000.0f) - 0.3f) *
          (mesh->size.y / 20.0f)
        )
      );

      mesh->vertices[index_vertex + 1].x = position_joint_branch.x;
      mesh->vertices[index_vertex + 1].y = position_joint_branch.y;
      mesh->vertices[index_vertex + 1].z = position_joint_branch.z;
      mesh->vertices[index_vertex + 1].w = 1.0f;

      if (
        index_joint_branch != 0
      ) {
        position_joint_branch.y = (
          position_joint_branch.y + (
            ((((float)((
              rand_result_secondary.bytes[offset_byte + 8] *
              rand_result_secondary.bytes[offset_byte + 12]
            ) % 10000)) / 5000.0f) - 0.3f) * (mesh->size.y / 30.0f)
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
          ((((float)((
            rand_result_secondary.bytes[offset_byte + 14] *
            rand_result_secondary.bytes[offset_byte + 6]
          ) % 10000)) / 5000.0f) - 0.3f) * (mesh->size.y / 30.0f)
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
