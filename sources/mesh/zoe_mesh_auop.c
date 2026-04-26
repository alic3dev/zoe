#include <mesh/zoe_mesh_auop.h>

#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metil_mesh/metil_mesh.h>

void zoe_mesh_auop_initialize(
  struct metil_mesh* zoe_mesh_auop
) {
  metil_mesh_initialize_with_lengths(
    zoe_mesh_auop,
    zoe_mesh_auop_length_vertices,
    zoe_mesh_auop_length_indices
  );

  unsigned short int index_vertex;

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
      zoe_mesh_auop_length_segment_vertices_radial
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
        math_c_pi
      );

      zoe_mesh_auop->vertices[
        index_vertex
      ].x = (
        math_c_sine(
          angle,
          math_c_pi
        )
      );
    
      zoe_mesh_auop->vertices[
        index_vertex
      ].y = (
        percentage_segments *
        zoe_mesh_auop_height
      );

      zoe_mesh_auop->vertices[
        index_vertex
      ].z = (
        math_c_cosine(
          angle,
          math_c_pi
        )
      );

      zoe_mesh_auop->vertices[
        index_vertex
      ].w = (
        0x01
      );
    }
  }

  index_vertex = (
    zoe_mesh_auop->length_vertices -
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
  ].z = (
    0x00
  );
  
  zoe_mesh_auop->vertices[
    index_vertex
  ].w = (
    0x01
  );

  for (
    unsigned short int index_index = (
      0x00
    );
    (
      index_index <
      zoe_mesh_auop->length_indices
    );
    ++index_index
  ) {
    zoe_mesh_auop->indices[
      index_index
    ] = (
      index_index %
      zoe_mesh_auop->length_vertices
    );
  }    
}
