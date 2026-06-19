#include <zoe_mesh/mesh_zoe_hair.h>

#include <clic3_memory.h>

#include <math_c_absolute.h>
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
    length_segments *
    0x03
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
    -1.75f *
    1.5
  );

  float height_upper = (
    1.75f *
    1.5 -
    0.5f
  );

  float distance_height = (
    height_upper -
    height_lower
  );

  float height_top = (
    1.75f *
    1.5f
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
    
    float percentage_segment = (
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
    );

    float angle = (
      -percentage_segment *
      1.5f +
      math_c_pi_half *
      1.175f
    );

    float percentage_section = (
      (float)
      index_section /
      (float)
      (
        length_segment_sections -
        0x01
      )
    );

    float percentage_section_end = (
      0x01 -
      (float)
      index_section /
      (float)
      (
        length_segment_sections -
        0x01
      )
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
    
    float variation = (
      (float)
      (
        (
          offset_index_vertex *
          0x05 +
          offset_index_vertex +
          index_segment +
          (
            (
              offset_index_vertex *
              0x03
            ) %
            0x04
          )
        ) %
        0x0a
      ) /
      0x09 *
      0.25f *
      percentage_section
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
      (
        radius +
        variation
      )
    );
    
    variation = (
      (float)
      (
        (
          offset_index_vertex *
          0x03 +
          offset_index_vertex *
          0x02 +
          index_segment *
          0x03 +
          (
            (
              offset_index_vertex *
              0x06
            ) %
            0x07
          )
        ) %
        0x0b
      ) /
      0x0a *
      0.25f *
      percentage_section
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex
    ].y = (
      (
        index_segment >=
        length_segments_radial *
        0x02
      )
      ? (
        height_upper -
        (
          (
            percentage_section_end *
            0.9f +
            0.1f
          ) *
          distance_height
        ) -
        (
          math_c_absolute_float(
            math_c_cosine(
              angle *
              math_c_pi,
              math_c_pi
            )
          )
        ) *
        distance_height *
        (
          percentage_section_end *
          0.9f +
          0.1f
        ) *
        math_c_sine(
          percentage_segment *
          math_c_pi,
          math_c_pi
        ) +
        variation
      )
      : height_upper
    );
    
    variation = (
      (float)
      (
        (
          offset_index_vertex *
          0x02 +
          offset_index_vertex *
          0x08 +
          index_segment *
          0x02 +
          (
            (
              offset_index_vertex *
              0x05
            ) %
            0x06
          )
        ) %
        0x09
      ) /
      0x08 *
      0.125f *
      percentage_section
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
      (
        radius +
        variation
      )
    );

    angle = (
      angle -
      0.05f
    );
    
    variation = (
      (float)
      (
        (
          offset_index_vertex +
          offset_index_vertex *
          0x07 +
          index_segment *
          0x09 +
          (
            (
              offset_index_vertex *
              0x02
            ) %
            0x03
          )
        ) %
        0x0c
      ) /
      0x0b *
      0.25f *
      percentage_section
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex +
      0x01
    ].x = (
      lower
      ? (
        math_c_sine(
          (
            angle *
            math_c_pi
          ),
          math_c_pi
        ) *
        (
          variation +
          radius
        ) *
        0.9f
      )
      : (
        (
          (
            index_segment %
            0x02
          ) ==
          0x00
        )
        ? -0.1f
        : 0.1f
      )
    );
    
    variation = (
      (float)
      (
        (
          offset_index_vertex *
          0x04 +
          offset_index_vertex +
          0x05 +
          index_segment *
          0x02 +
          (
            (
              offset_index_vertex *
              0x09
            ) %
            0x05
          )
        ) %
        0x0e
      ) /
      0x0d *
      0.25f *
      percentage_section
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex +
      0x01
    ].y = (
      lower
      ? (
        height_upper +
        0.25f -
        (
          (
            percentage_section *
            0.9f +
            0.1f
          ) *
          (
            distance_height +
            variation
          )
        )
      )
      : height_top
    );
    
    variation = (
      (float)
      (
        (
          offset_index_vertex +
          offset_index_vertex *
          0x03 +
          index_segment *
          0x04 +
          (
            offset_index_vertex %
            0x02
          )
        ) %
        0x04
      ) /
      0x05 *
      0.125f *
      percentage_section
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
        (
          lower !=
          0x00
        )
        ? (
          (
            radius +
            variation
          ) *
          0.9f
        )
        : 0.8f
      )
    );

    angle = (
      angle -
      0.05f
    );
    
    variation = (
      (float)
      (
        (
          offset_index_vertex *
          0x05 +
          offset_index_vertex +
          0x0a +
          index_segment *
          0x08 +
          (
            (
              offset_index_vertex *
              0x04
            ) %
            0x09
          )
        ) %
        0x0a
      ) /
      0x09 *
      0.25f *
      percentage_section
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
      (
        radius +
        variation
      )
    );
    
    variation = (
      (float)
      (
        (
          offset_index_vertex *
          0x05 +
          offset_index_vertex +
          0x02 +
          index_segment *
          0x05 +
          (
            (
              offset_index_vertex *
              0x05
            ) %
            0x05
          )
        ) %
        0x08
      ) /
      0x07 *
      0.125f *
      percentage_section
    );

    metil_mesh_zoe_hair->vertices[
      offset_index_vertex +
      0x02
    ].y = (
      metil_mesh_zoe_hair->vertices[
        offset_index_vertex
      ].y +
      variation
    );
    
    variation = (
      (float)
      (
        (
          offset_index_vertex *
          0x03 +
          offset_index_vertex +
          0x06 +
          index_segment *
          0x05 +
          (
            (
              offset_index_vertex *
              0x04
            ) %
            0x03
          )
        ) %
        0x0e
      ) /
      0x0d *
      0.125f *
      percentage_section
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
      (
        radius +
        variation
      )
    );
  }
  
  struct math_c_vector2_float minimum_maximum_x = {
    .x = (
      0xff
    ),
    .y = (
      -0xff
    )
  };
  
  struct math_c_vector2_float minimum_maximum_y = {
    .x = (
      0xff
    ),
    .y = (
      -0xff
    )
  };
  
  struct math_c_vector2_float minimum_maximum_z = {
    .x = (
      0xff
    ),
    .y = (
      -0xff
    )
  };
  
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
    if (
      metil_mesh_zoe_hair->vertices[
        index_indices
      ].x <
      minimum_maximum_x.x
    ) {
      minimum_maximum_x.x = (
        metil_mesh_zoe_hair->vertices[
          index_indices
        ].x
      );
    }
    
    if (
      metil_mesh_zoe_hair->vertices[
        index_indices
      ].x >
      minimum_maximum_x.y
    ) {
      minimum_maximum_x.y = (
        metil_mesh_zoe_hair->vertices[
          index_indices
        ].x
      );
    }
    
    if (
      metil_mesh_zoe_hair->vertices[
        index_indices
      ].y <
      minimum_maximum_y.x
    ) {
      minimum_maximum_y.x = (
        metil_mesh_zoe_hair->vertices[
          index_indices
        ].y
      );
    }
    
    if (
      metil_mesh_zoe_hair->vertices[
        index_indices
      ].y >
      minimum_maximum_y.y
    ) {
      minimum_maximum_y.y = (
        metil_mesh_zoe_hair->vertices[
          index_indices
        ].y
      );
    }
    
    if (
      metil_mesh_zoe_hair->vertices[
        index_indices
      ].z <
      minimum_maximum_z.x
    ) {
      minimum_maximum_z.x = (
        metil_mesh_zoe_hair->vertices[
          index_indices
        ].z
      );
    }
    
    if (
      metil_mesh_zoe_hair->vertices[
        index_indices
      ].z >
      minimum_maximum_z.y
    ) {
      minimum_maximum_z.y = (
        metil_mesh_zoe_hair->vertices[
          index_indices
        ].z
      );
    }
  
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
  
  metil_mesh_zoe_hair->size.x = (
    (
      minimum_maximum_x.y -
      minimum_maximum_x.x
    ) /
    0x02
  );
  
  metil_mesh_zoe_hair->size.y = (
    (
      minimum_maximum_y.y -
      minimum_maximum_y.x
    ) /
    0x02
  );
  
  metil_mesh_zoe_hair->size.z = (
    (
      minimum_maximum_z.y -
      minimum_maximum_z.x
    ) /
    0x02
  );
}
