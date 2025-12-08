#include <mesh/mesh_tree.h>

#include <clic3_vector.h>

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
  struct clic3_vector2_float* size
) {
  metil_mesh_initialize(
    mesh
  );

  mesh->size.x = (
    size->x *
    2.0f
  );
  mesh->size.y = size->y;
  mesh->size.z = mesh->size.x;

  float interval_height = (
    mesh->size.y /
    (float) (
      zoe_mesh_tree_length_segments_height -
      1
    )
  );

  mesh->length_vertices = (
    zoe_mesh_tree_length_vertices_trunk
  );

  mesh->length_indices = (
    (zoe_mesh_tree_length_segments_height - 1) * 
    zoe_mesh_tree_length_vertices_radius *
    6
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

  float radius_tenth = (
    size->x /
    10.0f
  );
  float radius_nine_tenths = (
    radius_tenth *
    9.0f
  );

  unsigned int index_index = 0;

  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  rand_initialize(
    &rand_parameters,
    &rand_result,
    &rand_source, (
      zoe_mesh_tree_length_segments_height *
      zoe_mesh_tree_length_vertices_radius *
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
    index_segment_height < zoe_mesh_tree_length_segments_height;
    ++index_segment_height
  ) {
    unsigned int index_offset_height = (
      index_segment_height *
      zoe_mesh_tree_length_vertices_radius
    );

    for (
      unsigned char index_segment_radius = 0;
      index_segment_radius < zoe_mesh_tree_length_vertices_radius;
      ++index_segment_radius
    ) {
      unsigned int index_vertex = (
        index_offset_height +
        index_segment_radius
      );

      float distance = (
        fmod(
          (float) (
            rand_result.bytes[
              index_vertex +
              1
            ] *
            rand_result.bytes[
              index_vertex +
              2
            ]
          ) /
          1000.0f,
          radius_nine_tenths
        ) + radius_tenth
      );

      float angle = (
        (float) index_segment_radius /
        (float) zoe_mesh_tree_length_vertices_radius *
        M_PI *
        2.0f
      );
      
      mesh->vertices[index_vertex].x = (
        cosf(
          angle
        ) *
        distance
      );
      mesh->vertices[index_vertex].y = (
        index_segment_height *
        interval_height
      );
      mesh->vertices[index_vertex].z = (
        sinf(
          angle
        ) *
        distance
      );
      mesh->vertices[index_vertex].w = 1.0f;

      if (
        index_segment_height >= (
          zoe_mesh_tree_length_segments_height -
          1
        )
      ) {
        continue;
      }

      if (
        zoe_mesh_tree_length_vertices_radius > (
          index_segment_radius +
          1
        )
      ) {
        mesh->indices[index_index++] = index_vertex;
        mesh->indices[index_index++] = index_vertex + 1;
        mesh->indices[index_index++] = index_vertex + zoe_mesh_tree_length_vertices_radius;

        mesh->indices[index_index++] = index_vertex + 1;
        mesh->indices[index_index++] = index_vertex + zoe_mesh_tree_length_vertices_radius;
        mesh->indices[index_index++] = index_vertex + zoe_mesh_tree_length_vertices_radius + 1;
      } else {
        mesh->indices[index_index++] = index_vertex;
        mesh->indices[index_index++] = (index_vertex + 1) - zoe_mesh_tree_length_vertices_radius;
        mesh->indices[index_index++] = index_vertex + zoe_mesh_tree_length_vertices_radius;

        mesh->indices[index_index++] = index_vertex + 1;
        mesh->indices[index_index++] = (index_vertex + 1) - zoe_mesh_tree_length_vertices_radius;
        mesh->indices[index_index++] = index_vertex + zoe_mesh_tree_length_vertices_radius;
      }
    }
  }

  unsigned char count_branches = (
    rand_result.bytes[0] % 10
  ) + 50;

  float radius_branch_tenth = (
    (size->x / 2.0f) /
    10.0f
  );
  float radius_branch_nine_tenths = radius_branch_nine_tenths * 9.0f;

  unsigned char zoe_mesh_tree_length_vertices_radius_branch = zoe_mesh_tree_length_vertices_radius / 2;

  if (zoe_mesh_tree_length_vertices_radius_branch % 2 != 0) {
    zoe_mesh_tree_length_vertices_radius_branch = (
      zoe_mesh_tree_length_vertices_radius_branch + 1
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
      index_branch *
      155
    );

    unsigned int index_vertex = (
      mesh->length_vertices
    );

    unsigned char count_joints_branch = (
      rand_result_secondary.bytes[
        offset_byte +
        10
      ] % 10
    ) + 5;

    mesh->length_vertices = (
      mesh->length_vertices + 
      (count_joints_branch * 4)
    );

    mesh->length_indices = (
      mesh->length_indices + 
      (count_joints_branch * 24) 
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

    offset_byte = (
      offset_byte +
      5
    );

    for (
      unsigned char index_joint_branch = 0;
      index_joint_branch < count_joints_branch;
      ++index_joint_branch
    ) {
      offset_byte = (
        offset_byte + 
        6
      );

      float length = (
        ((float)((
          rand_result_secondary.bytes[offset_byte + 2] *
          rand_result_secondary.bytes[offset_byte + 3]
        ) % 10000) / 100.0f)
      );

      float thickness = (
        size->x /
        10.0f
      );
      
      mesh->vertices[index_vertex].x = position_joint_branch.x - thickness;
      mesh->vertices[index_vertex].y = position_joint_branch.y;
      mesh->vertices[index_vertex].z = position_joint_branch.z - thickness;
      mesh->vertices[index_vertex].w = 1.0f;
      

      mesh->vertices[index_vertex + 1].x = position_joint_branch.x;
      mesh->vertices[index_vertex + 1].y = position_joint_branch.y + thickness;
      mesh->vertices[index_vertex + 1].z = position_joint_branch.z;
      mesh->vertices[index_vertex + 1].w = 1.0f;

      mesh->vertices[index_vertex + 2].x = position_joint_branch.x + thickness;
      mesh->vertices[index_vertex + 2].y = position_joint_branch.y;
      mesh->vertices[index_vertex + 2].z = position_joint_branch.z + thickness;
      mesh->vertices[index_vertex + 2].w = 1.0f;

      mesh->vertices[index_vertex + 3].x = position_joint_branch.x;
      mesh->vertices[index_vertex + 3].y = position_joint_branch.y - thickness;
      mesh->vertices[index_vertex + 3].z = position_joint_branch.z;
      mesh->vertices[index_vertex + 3].w = 1.0f;

      if (
        index_joint_branch < count_joints_branch - 1
      ) {
        mesh->indices[index_index++] = index_vertex;
        mesh->indices[index_index++] = index_vertex + 1;
        mesh->indices[index_index++] = index_vertex + 4;

        mesh->indices[index_index++] = index_vertex + 4;
        mesh->indices[index_index++] = index_vertex + 5;
        mesh->indices[index_index++] = index_vertex + 1;

        mesh->indices[index_index++] = index_vertex + 1;
        mesh->indices[index_index++] = index_vertex + 2;
        mesh->indices[index_index++] = index_vertex + 5;

        mesh->indices[index_index++] = index_vertex + 5;
        mesh->indices[index_index++] = index_vertex + 6;
        mesh->indices[index_index++] = index_vertex + 2;

        mesh->indices[index_index++] = index_vertex + 2;
        mesh->indices[index_index++] = index_vertex + 3;
        mesh->indices[index_index++] = index_vertex + 6;

        mesh->indices[index_index++] = index_vertex + 6;
        mesh->indices[index_index++] = index_vertex + 7;
        mesh->indices[index_index++] = index_vertex + 3;

        mesh->indices[index_index++] = index_vertex + 3;
        mesh->indices[index_index++] = index_vertex;
        mesh->indices[index_index++] = index_vertex + 7;

        mesh->indices[index_index++] = index_vertex + 7;
        mesh->indices[index_index++] = index_vertex + 4;
        mesh->indices[index_index++] = index_vertex;

        position_joint_branch.x = (
          position_joint_branch.x +
          cosf(angle) * (length)
        );

        position_joint_branch.y = (
          position_joint_branch.y + (
            ((((float)((
              rand_result_secondary.bytes[offset_byte + 4] *
              rand_result_secondary.bytes[offset_byte + 5]
            ) % 10000)) / 5000.0f) - 0.3f) *
            (mesh->size.y / 20.0f)
          )
        );

        position_joint_branch.z = (
          position_joint_branch.z +
          sinf(angle) * (length)
        );

        angle = (
          angle + (
            ((float) (
              rand_result_secondary.bytes[offset_byte + 6]
            ) / 127.5f - 1.0f)
          ) / 1.0f
        );
      } else {
        mesh->indices[index_index++] = index_vertex;
        mesh->indices[index_index++] = index_vertex + 1;
        mesh->indices[index_index++] = index_vertex + 2;

        mesh->indices[index_index++] = index_vertex + 3;
        mesh->indices[index_index++] = index_vertex + 2;
        mesh->indices[index_index++] = index_vertex + 1;

        mesh->indices[index_index++] = index_vertex;
        mesh->indices[index_index++] = index_vertex + 2;
        mesh->indices[index_index++] = index_vertex + 1;

        mesh->indices[index_index++] = index_vertex + 3;
        mesh->indices[index_index++] = index_vertex + 2;
        mesh->indices[index_index++] = index_vertex;

        mesh->indices[index_index++] = index_vertex + 1;
        mesh->indices[index_index++] = index_vertex + 3;
        mesh->indices[index_index++] = index_vertex + 2;

        mesh->indices[index_index++] = index_vertex + 2;
        mesh->indices[index_index++] = index_vertex;
        mesh->indices[index_index++] = index_vertex + 1;

        mesh->indices[index_index++] = index_vertex + 3;
        mesh->indices[index_index++] = index_vertex + 2;
        mesh->indices[index_index++] = index_vertex;

        mesh->indices[index_index++] = index_vertex + 1;
        mesh->indices[index_index++] = index_vertex + 3;
        mesh->indices[index_index++] = index_vertex + 2;
      }

      index_vertex = (
        index_vertex + 4
      );
    }
  }
}
