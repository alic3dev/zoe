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

  unsigned short int length_segments_radial = (
    0xa0
  );

  unsigned short int length_segment_sections = (
    0x06
  );

  unsigned short int length_segments = (
    length_segments_radial *
    length_segment_sections
  );

  metil_mesh_zoe_hair->length_vertices = (
    0x3 *
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

  float height_lower = (
    -1.0f
  );

  float height_upper = (
    2.0f
  );

  float distance_height = (
    height_upper -
    height_lower
  );

  float height_top = (
    2.5f
  );

  for (
    unsigned short int index_segment = (
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

    unsigned char lower = (
      index_segment >=
      length_segments_radial
    );

    unsigned short int index_section = (
      index_segment /
      length_segments_radial
    );

    float angle = (
      -(
        (float)
        (
          index_segment %
          length_segments_radial
        ) /
        (float)
        (
          length_segments_radial -
          0x01
        )
      ) *
      1.5f +
      math_c_pi_half *
      1.175f
    );

    float percentage_section = (
      (float)
      (index_section - 0x01) /
      (float)
      length_segment_sections
    );

    float percentage_section_end = (
      (float)
      (
        index_section +
        0x00
      ) /
      (float)
      length_segment_sections
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
      lower
      ? (
        height_upper -
        (
          percentage_section_end *
          distance_height
        )
      )
      : height_upper
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
      lower
      ?
math_c_sine(
        (
          angle *
          math_c_pi
        ),
        math_c_pi
      ) * radius * 0.9f      : (
        index_segment % 2 == 0x00
      ) ? -0.1f : 0.1f
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex +
      0x01
    ].y = (
      lower
      ? (
        height_upper + 0.25f -
        (
          percentage_section *
          distance_height
        )
      )
      : height_top
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
      (
        lower
        ? radius * 0.9f
        : (
          0.8f        )
      )
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
      metil_mesh_zoe_hair->vertices[
        offset_index_vertex
      ].y    );

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
