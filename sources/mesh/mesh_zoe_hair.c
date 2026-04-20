#include <mesh/mesh_zoe_hair.h>

#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>

#include <metil_mesh/metil_mesh.h>

void mesh_zoe_hair_initialize(
  struct metil_mesh* metil_mesh_zoe_hair
) {
  metil_mesh_initialize(
    metil_mesh_zoe_hair
  );

  unsigned char length_segments = (
    0xa0
  );

  metil_mesh_zoe_hair->length_vertices = (
    0x03 *
    length_segments
  );

  metil_mesh_zoe_hair->length_indices = (
    metil_mesh_zoe_hair->length_vertices
  );

  clic3_memory_reallocate_raw(
    &metil_mesh_zoe_hair->vertices,
    (
      sizeof(
        struct math_c_vector4_float
      ) *
      metil_mesh_zoe_hair->length_vertices
    )
  );

  clic3_memory_reallocate_raw(
    &metil_mesh_zoe_hair->indices,
    (
      sizeof(
        unsigned int
      ) *
      metil_mesh_zoe_hair->length_indices
    )
  );

  for (
    unsigned char index_segment = (
      0x00
    );
    (
      index_segment <
      length_segments
    );
    ++index_segment
  ) {
    unsigned int offset_index_vertex = (
      index_segment *
      0x03
    );

    float angle = (
      -(
        (float)
        index_segment /
        (float)
        (
          length_segments -
          0x01
        )
      ) +
      math_c_pi_half
    );

    float radius = (
      1.25f +
      math_c_sine(
        (
          (
            angle -
            math_c_pi_half
          ) *
          math_c_pi *
          10.548f
        ),
        math_c_pi
      ) *
      0.2f
    );
    
    metil_mesh_zoe_hair->vertices[
      offset_index_vertex
    ].x = (
      math_c_sine(
        (
          angle *
          math_c_pi
        ),
        math_c_pi
      ) *
      radius
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex
    ].y = (
      -1.0f
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex
    ].z = (
      math_c_cosine(
        (
          angle *
          math_c_pi
        ),
        math_c_pi
      ) *
      radius
    );

    angle = (
      angle -
      0.05f
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex +
      0x01
    ].x = (
      math_c_sine(
        (
          angle *
          math_c_pi
        ),
        math_c_pi
      ) *
      radius *
      0.5f
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex +
      0x01
    ].y = (
      2.0f
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex +
      0x01
    ].z = (
      math_c_cosine(
        (
          angle *
          math_c_pi
        ),
        math_c_pi
      ) *
      radius *
      0.1f
    );

    angle = (
      angle -
      0.05f
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex +
      0x02
    ].x = (
      math_c_sine(
        (
          angle *
          math_c_pi
        ),
        math_c_pi
      ) *
      radius
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex +
      0x02
    ].y = (
      -1.0f
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex +
      0x02
    ].z = (
      math_c_cosine(
        (
          angle *
          math_c_pi
        ),
        math_c_pi
      ) *
      radius
    );
  }

  for (
    unsigned int index_indices = (
      0x00
    );
    (
      index_indices <
      metil_mesh_zoe_hair->length_indices
    );
    ++index_indices
  ) {
    metil_mesh_zoe_hair->vertices[
      index_indices
    ].w = (
      0x01
    );

    metil_mesh_zoe_hair->indices[
      index_indices
    ] = (
      index_indices
    );
  }
}
