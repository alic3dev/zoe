#include <mesh/mesh_ground.h>

#include <clic3_memory.h>

#include <metil_mesh/metil_mesh.h>

#include <math_c_vector.h>

#include <rand_functions.h>
#include <rand_initialize.h>
#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>
#include <rand_source_type.h>

const struct math_c_vector2_unsigned_int mesh_ground_length_vertices = {
  .x = (
    length_vertices_ground_x
  ),  .y = (
    length_vertices_ground_y
  )
};

void mesh_ground_initialize(
  struct metil_mesh* mesh,
  struct math_c_vector3_float* size
) {
  metil_mesh_initialize(
    mesh
  );

  mesh->size.x = (
    size->x
  );
  
  mesh->size.y = (
    size->y
  );
  
  mesh->size.z = (
    size->z
  );

  mesh->length_vertices = (
    mesh_ground_length_vertices.x *
    mesh_ground_length_vertices.y
  );

  mesh->length_indices = (
    (
      mesh_ground_length_vertices.x -
      0x01
    ) *
    (
      mesh_ground_length_vertices.y -
      0x01
    ) *
    0x06
  );

  clic3_memory_reallocate_raw(
    &mesh->vertices,
    (
      sizeof(
        struct math_c_vector4_float
      ) *
      mesh->length_vertices
    )
  );

  clic3_memory_reallocate_raw(
    &mesh->indices,
    (
      sizeof(
        unsigned int
      ) *
      mesh->length_indices
    )
  );

  const struct math_c_vector2_float increment_ground = {
    .x = (
      mesh->size.x /
      (float)
      mesh_ground_length_vertices.x
    ),
    .y = (
      mesh->size.z /
      (float)
      mesh_ground_length_vertices.y
    )
  };

  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  rand_initialize(
    &rand_parameters,
    &rand_result,
    &rand_source, (
      mesh_ground_length_vertices.x *
      mesh_ground_length_vertices.y *
      0x06
    ),
    rand_mode_bytes,
    rand_source_type_divisive
  );

  rand_get(
    &rand_source,
    &rand_result,
    &rand_parameters
  );

  unsigned int index_vertex_ground = (
    0x00
  );

  unsigned int offset_byte = (
    0x00
  );
  
  for (
    unsigned int index_x = (
      0x00
    );
    (
      index_x <
      mesh_ground_length_vertices.x
    );
    ++index_x
  ) {
    for (
      unsigned int index_z = (
        0x00
      );
      (
        index_z <
        mesh_ground_length_vertices.y
      );
      ++index_z
    ) {
      offset_byte = (
        (
          index_x +
          (
            index_z *
            mesh_ground_length_vertices.x
          ) *
          0x06
        )
      );

      mesh->vertices[
        index_vertex_ground
      ].x = (
        (
          index_x *
          increment_ground.x
        ) -
        (
          mesh->size.x /
          2.0f
        )
      );

      mesh->vertices[
        index_vertex_ground
      ].z = (
        (
          index_z *
          increment_ground.y
        ) -
        (
          mesh->size.z /
          2.0f
        )
      );

      if (
        (
          index_x >
          (
            mesh_ground_length_vertices.x *
            0.1
          )
        ) &&
        (
          index_x <
          (
            mesh_ground_length_vertices.x *
            0.9
          )
        ) &&
        (
          index_z >
          (
            mesh_ground_length_vertices.y *
            0.1
          )
        ) &&
        (
          index_z <
          (
            mesh_ground_length_vertices.y *
            0.9
          )
        )
      ) {
        mesh->vertices[
          index_vertex_ground
        ].y = (
          (float)
          (
            (
              rand_result.bytes[
                offset_byte
              ] *
              rand_result.bytes[
                offset_byte +
                0x01
              ]
            ) %
            0x03e8
          ) /
          1000.0f *
          4.0f -
          2.0f
        );
      } else if (
        (
          index_vertex_ground %
          0x04
        ) ==
        0x00
      ) {
        mesh->vertices[
          index_vertex_ground
        ].y = (
          (float)
          (
            (
              rand_result.bytes[
                offset_byte +
                0x02
              ] *
              rand_result.bytes[
                offset_byte +
                0x03
              ]
            ) %
            0x01f4
          ) /
          1000.0f *
          mesh->size.y +
          (
            mesh->size.y /
            2.0f
          )
        );
      } else {
        mesh->vertices[
          index_vertex_ground
        ].y = (
          (float) (
            (
              rand_result.bytes[
                offset_byte +
                0x04
              ] *
              rand_result.bytes[
                offset_byte +
                0x05
              ]
            ) %
            0x0190
          ) /
          1000.0f *
          mesh->size.y +
          (
            mesh->size.y *
            0.6f
          )
        );
      }

      mesh->vertices[
        index_vertex_ground
      ].w = (
        0x01
      );

      index_vertex_ground = (
        index_vertex_ground +
        0x01
      );
    }
  }

  unsigned int index_index_ground = (
    0x00
  );

  for (
    unsigned char index_x = (
      0x00
    );
    (
      index_x <
      (
        mesh_ground_length_vertices.x -
        0x01
      )
    );
    ++index_x
  ) {
    for (
      unsigned char index_z = (
        0x00
      );
      (
        index_z <
        (
          mesh_ground_length_vertices.y -
          0x01
        )
      );
      ++index_z
    ) {
      mesh->indices[
        index_index_ground
      ] = (
        index_x *
        mesh_ground_length_vertices.y +
        index_z
      );

      index_index_ground = (
        index_index_ground +
        0x01
      );

      mesh->indices[
        index_index_ground
      ] = (
        index_x *
        mesh_ground_length_vertices.y +
        index_z +
        0x01      );

      index_index_ground = (
        index_index_ground +
        0x01
      );

      mesh->indices[
        index_index_ground
      ] = (
        (
          index_x +
          0x01
        ) *
        mesh_ground_length_vertices.y +
        index_z
      );

      index_index_ground = (
        index_index_ground +
        0x01
      );

      mesh->indices[
        index_index_ground
      ] = (
        index_x *
        mesh_ground_length_vertices.y +
        index_z +
        0x01
      );

      index_index_ground = (
        index_index_ground +
        0x01
      );

      mesh->indices[
        index_index_ground
      ] = (
        (
          index_x +
          0x01
        ) *
        mesh_ground_length_vertices.y +
        index_z
      );

      index_index_ground = (
        index_index_ground +
        0x01
      );

      mesh->indices[
        index_index_ground
      ] = (
        (
          index_x +
          0x01
        ) *
        mesh_ground_length_vertices.y +
        index_z +
        0x01
      );

      index_index_ground = (
        index_index_ground +
        0x01
      );
    }
  }
}
