#include <mesh/mesh_hill.h>

#include <calculations/hill_y_value.h>

#include <metil_mesh/metil_mesh.h>

#include <clic3_vector.h>

#include <rand_functions.h>
#include <rand_initialize.h>
#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>
#include <rand_source_type.h>

#include <stdlib.h>

const struct clic3_vector2_unsigned_int mesh_hill_length_vertices = {
  .x = length_vertices_hill_x,
  .y = length_vertices_hill_y
};

void mesh_hill_initialize(
  struct metil_mesh* metil_mesh
) {
  struct clic3_vector3_float size = {
    .x = mesh_hill_length_vertices.x * 2.0f,
    .y = 333.3f,
    .z = mesh_hill_length_vertices.y * 2.0f
  };

  metil_mesh_initialize(
    metil_mesh
  );

  metil_mesh->size.x = size.x;
  metil_mesh->size.y = size.y;
  metil_mesh->size.z = size.z;

  metil_mesh->length_vertices = (
    mesh_hill_length_vertices.x *
    mesh_hill_length_vertices.y
  );

  metil_mesh->length_indices = (
    (mesh_hill_length_vertices.x - 1) *
    (mesh_hill_length_vertices.y - 1) *
    6
  );

  metil_mesh->vertices = realloc(
    metil_mesh->vertices,
    sizeof(struct clic3_vector4_float) *
    metil_mesh->length_vertices
  );

  metil_mesh->indices = realloc(
    metil_mesh->indices,
    sizeof(unsigned int) *
    metil_mesh->length_indices
  );

  const struct clic3_vector2_float increment_hill = {
    .x = (
      metil_mesh->size.x /
      (float) (mesh_hill_length_vertices.x)
    ),
    .y = (
      metil_mesh->size.z /
      (float) (mesh_hill_length_vertices.y)
    )
  };

  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  rand_initialize(
    &rand_parameters,
    &rand_result,
    &rand_source, (
      mesh_hill_length_vertices.x *
      mesh_hill_length_vertices.y *
      6
    ),
    rand_mode_bytes,
    rand_source_type_divisive
  );

  rand_get(
    &rand_source,
    &rand_result,
    &rand_parameters
  );

  unsigned int index_vertex_hill = 0;

  for (
    unsigned int index_x = 0;
    index_x < mesh_hill_length_vertices.x;
    ++index_x
  ) {
    for (
      unsigned int index_z = 0;
      index_z < mesh_hill_length_vertices.y;
      ++index_z
    ) {

      metil_mesh->vertices[
        index_vertex_hill
      ].x = (
        (
          index_x *
          increment_hill.x
        ) - (
          metil_mesh->size.x /
          2.0f
        )
      );

      struct clic3_vector2_float position_percentage = {
        .x = (
          (float) index_x /
          (float) (
            mesh_hill_length_vertices.x -
            1
          )
        ),
        .y = (
          (float) index_z /
          (float) (
            mesh_hill_length_vertices.y -
            1
          )
        )
      };

      if (
        position_percentage.x >= 0.5f
      ) {
        position_percentage.x = (
          position_percentage.x -
          0.5f
        );
      } else {
        position_percentage.x = (
          0.5f -
          position_percentage.x
        );
      }

      if (
        position_percentage.y >= 0.5f
      ) {
        position_percentage.y = (
          position_percentage.y -
          0.5f
        );
      } else {
        position_percentage.y = (
          0.5f -
          position_percentage.y
        );
      }

      metil_mesh->vertices[
        index_vertex_hill
      ].y = (
        hill_y_value_get(
          &position_percentage
        )
      );
      
      metil_mesh->vertices[
        index_vertex_hill
      ].z = (
        (
          index_z *
          increment_hill.y
        ) - (
          metil_mesh->size.z /
          2.0f
        )
      );

      metil_mesh->vertices[
        index_vertex_hill
      ].w = (
        1.0f
      );

      index_vertex_hill = (
        index_vertex_hill + 1
      );
    }
  }

  unsigned int index_index_hill = 0;

  for (
    unsigned int index_x = 0;
    index_x < (
      mesh_hill_length_vertices.x -
      1
    );
    ++index_x
  ) {
    for (
      unsigned int index_z = 0;
      index_z < (
        mesh_hill_length_vertices.y -
        1
      );
      ++index_z
    ) {
      metil_mesh->indices[
        index_index_hill
      ] = (
        index_x *
        mesh_hill_length_vertices.y +
        index_z
      );

      index_index_hill = (
        index_index_hill + 1
      );

      metil_mesh->indices[
        index_index_hill
      ] = (
        index_x *
        mesh_hill_length_vertices.y +
        index_z +
        1
      );

      index_index_hill = (
        index_index_hill +
        1
      );

      metil_mesh->indices[
        index_index_hill
      ] = (
        (
          index_x +
          1
        ) *
        mesh_hill_length_vertices.y +
        index_z
      );

      index_index_hill = (
        index_index_hill +
        1
      );

      metil_mesh->indices[
        index_index_hill
      ] = (
        index_x *
        mesh_hill_length_vertices.y +
        index_z +
        1
      );

      index_index_hill = (
        index_index_hill +
        1
      );

      metil_mesh->indices[
        index_index_hill
      ] = (
        (
          index_x +
          1
        ) *
        mesh_hill_length_vertices.y +
        index_z
      );

      index_index_hill = (
        index_index_hill +
        1
      );

      metil_mesh->indices[
        index_index_hill
      ] = (
        (
          index_x +
          1
        ) *
        mesh_hill_length_vertices.y +
        index_z +
        1
      );

      index_index_hill = (
        index_index_hill +
        1
      );
    }
  }
}
