#include <mesh/zoe_mesh_auop.h>

#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metil_mesh/metil_mesh.h>
#include <stdio.h>
void zoe_mesh_auop_initialize(
  struct metil_mesh* zoe_mesh_auop
) {
  metil_mesh_initialize_with_lengths(
    zoe_mesh_auop,
    zoe_mesh_auop_length_vertices,
    zoe_mesh_auop_length_indices
  );

  zoe_mesh_auop->size.x = (
    0x02
  );

  zoe_mesh_auop->size.y = (
    zoe_mesh_auop_height
  );

  zoe_mesh_auop->size.z = (
    0x03
  );

  unsigned short int index_vertex = (
    0x00
  );

  unsigned short int index_index = (
    0x00
  );

  zoe_mesh_auop->vertices[
    index_vertex
  ].x = (
    0x00
  );

  zoe_mesh_auop->vertices[
    index_vertex
  ].y = (
    0x00
  );

  zoe_mesh_auop->vertices[
    index_vertex
  ].z = (
    0x00
  );

  zoe_mesh_auop->vertices[
    index_vertex
  ].w = (
    0x01
  );

  for (
    unsigned char index_segment = (
      0x00
    );
    (
      index_segment <
      zoe_mesh_auop_length_segments
    );
    ++index_segment
  ) {
    unsigned short int offset_vertex = (
      index_segment *
      zoe_mesh_auop_length_segment_vertices_radial +
      0x01
    );

    float percentage_segments = (
      (float)
      index_segment /
      (float)
      zoe_mesh_auop_length_segments
    );

    for (
      unsigned char index_segment_vertex_radial = (
        0x00
      );
      (
        index_segment_vertex_radial <
        zoe_mesh_auop_length_segment_vertices_radial
      );
      ++index_segment_vertex_radial
    ) {
      index_vertex = (
        index_segment_vertex_radial +
        offset_vertex
      );

      float angle = (
        (float)
        index_segment_vertex_radial /
        (float)
        zoe_mesh_auop_length_segment_vertices_radial *
        math_c_pi_doubled
      );

      float radius_x = (
        zoe_mesh_auop->size.x
      );

      float height = (
        zoe_mesh_auop->size.y
      );
  
      float radius_z = (
        zoe_mesh_auop->size.z
      );

      if (
        (
          percentage_segments <=
          0.75f
        ) &&
        (
          (
            angle <=
            (
              math_c_pi *
              0.5f
            )
          ) ||
          (
            angle >=
            (
              math_c_pi *
              1.5f
            )
          )
        )
      ) {
        radius_z = (
          radius_z -
          radius_z *
          math_c_sine(
            (
              percentage_segments /
              0.75f *
              math_c_pi_half
            ),
            math_c_pi
          )
        );
      }
    
      if (
        percentage_segments >=
        0.75f
      ) {
        float percentage_spanned = (
          math_c_sine(
            (
              (
                percentage_segments -
                0.75f
              ) /
              0.25f *              math_c_pi_half
            ),
            math_c_pi
          ) *
          0.25f
        );

        radius_x = (
          radius_x -
          radius_x *
          percentage_spanned *
          0x02
        );

        radius_z = (
          radius_z -
          zoe_mesh_auop->size.z *
          percentage_spanned
        );

        if (
          (
            angle <=
            (
              math_c_pi *
              0.5f            )
          ) ||
          (
            angle >=
            (
              math_c_pi *
              1.5f
            )
          )
        ) {
          if (
            angle >=
            math_c_pi *
            0.25f
          ) {
          height = (
            height +
            percentage_spanned *
            height
          );
          }
  
          radius_z = (
            radius_z -
            zoe_mesh_auop->size.z
          );
        }      }
          
      zoe_mesh_auop->vertices[
        index_vertex
      ].x = (
        math_c_sine(
          angle,
          math_c_pi
        ) *
        radius_x
      );
    
      zoe_mesh_auop->vertices[
        index_vertex
      ].y = (
        percentage_segments *
        height
      );

      zoe_mesh_auop->vertices[
        index_vertex
      ].z = (
        math_c_cosine(
          angle,
          math_c_pi
        ) *
        radius_z
      );

      zoe_mesh_auop->vertices[
        index_vertex
      ].w = (
        0x01
      );

      if (
        (
          index_segment +
          0x01
        ) ==
        zoe_mesh_auop_length_segments
      ) {
        continue;
      }

      zoe_mesh_auop->indices[
        index_index
      ] = (
        index_vertex
      );

      if (
        index_segment_vertex_radial ==
        (
          zoe_mesh_auop_length_segment_vertices_radial -
          0x01
        )
      ) {
        zoe_mesh_auop->indices[
          index_index +
          0x01
        ] = (
          offset_vertex
        );
      } else {
        zoe_mesh_auop->indices[
          index_index +
          0x01
        ] = (
          index_vertex +
          0x01
        );
      }
      zoe_mesh_auop->indices[
        index_index +
        0x02
      ] = (
        index_vertex +
        zoe_mesh_auop_length_segment_vertices_radial
      );

      zoe_mesh_auop->indices[
        index_index +
        0x03
      ] = (
        zoe_mesh_auop->indices[
          index_index +
          0x01
        ]
      );

      zoe_mesh_auop->indices[
        index_index +
        0x04
      ] = (
        zoe_mesh_auop->indices[
          index_index +
          0x02
        ]
      );
    
      zoe_mesh_auop->indices[
        index_index +
        0x05
      ] = (
        zoe_mesh_auop->indices[
          index_index +
          0x01
        ] +
        zoe_mesh_auop_length_segment_vertices_radial
      );

      index_index = (
        index_index +
        0x06
      );
    }
  }

  for (
    unsigned char index_upper_lower = (
      0x00
    );
    (
      index_upper_lower <
      0x02
    );
    ++index_upper_lower
  ) {
    unsigned short int index_vertex_center;
    unsigned short int index_vertex_offset;

    if (
      index_upper_lower ==
      0x00
    ) {
      index_vertex_center = (
        0x00
      );

      index_vertex_offset = (
        0x01
      );
    } else {
      index_vertex_center = (
        zoe_mesh_auop->length_vertices -
        0x01
      );

      index_vertex_offset = (
        index_vertex_center -
        zoe_mesh_auop_length_segment_vertices_radial -
        0x02
      );
    }

    for (
      unsigned char index_vertex_radial = (
        0x00
      );
      (
        index_vertex_radial <
        zoe_mesh_auop_length_segment_vertices_radial
      );
      ++index_vertex_radial
    ) {
      zoe_mesh_auop->indices[
        index_index
      ] = (
        index_vertex_center
      );

      zoe_mesh_auop->indices[
        index_index +
        0x01
      ] = (
        index_vertex_radial +
        index_vertex_offset
      );

      zoe_mesh_auop->indices[
        index_index +
        0x02
      ] = (
        (
          (
            index_vertex_radial +
            0x01
          ) %
          zoe_mesh_auop_length_segment_vertices_radial
        ) +
        index_vertex_offset
      );

      index_index = (
        index_index +
        0x03
      );
    }
  }

  index_vertex = (
    index_vertex +
    0x01
  );

  zoe_mesh_auop->vertices[
    index_vertex
  ].x = (
    0x00
  );

  zoe_mesh_auop->vertices[
    index_vertex
  ].y = (
    zoe_mesh_auop_height
  );

  zoe_mesh_auop->vertices[
    index_vertex
  ].z = -(
    zoe_mesh_auop->size.z /    0x02  );
  
  zoe_mesh_auop->vertices[
    index_vertex
  ].w = (
    0x01
  );    
}
