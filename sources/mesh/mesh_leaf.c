#include <mesh/mesh_leaf.h>

#include <metil_mesh/metil_mesh.h>

#include <math.h>
#include <stdlib.h>

void mesh_leaf_initialize(
  struct metil_mesh* metil_mesh_leaf
) {
  metil_mesh_initialize(
    metil_mesh_leaf
  );

  metil_mesh_leaf->size.x = (
    4.0f
  );

  metil_mesh_leaf->size.y = (
    10.0f
  );

  metil_mesh_leaf->size.z = (
    1.0f
  );

  unsigned char length_segments_radial = (
    10
  );

  unsigned char length_segments_stem = (
    6
  );

  unsigned char length_segments_vein = (
    2
  );

  struct math_c_vector2_float radius_stem = {
    .x = (
      metil_mesh_leaf->size.x /
      4.0f
    ),
    .y = (
      metil_mesh_leaf->size.z /
      4.0f
    )
  };

  struct math_c_vector2_float radius_vein = {
    .x = (
      radius_stem.x /
      2.0f
    ),
    .y = (
      radius_stem.y /
      2.0f
    )
  };

  float height_stem = (
    metil_mesh_leaf->size.y *
    0.9f
  );

  float height_stem_segment = (
    height_stem /
    (float) length_segments_stem
  );

  unsigned char length_vertices_stem = (
    length_segments_radial *
    length_segments_stem +
    2
  );

  unsigned char length_vertices_vein = (
    length_segments_radial *
    length_segments_vein +
    2
  );

  unsigned char length_vertices_outer = (
    11
  );

  metil_mesh_leaf->length_vertices = (
    length_vertices_stem +
    length_vertices_vein +
    length_vertices_outer
  );

  metil_mesh_leaf->length_indices = (
    (
      length_vertices_stem -
      2
    ) *
    6 +
    2 *
    length_segments_radial *
    3
  );

  metil_mesh_leaf->vertices = realloc(
    metil_mesh_leaf->vertices,
    sizeof(struct math_c_vector4_float) *
    metil_mesh_leaf->length_vertices
  );

  metil_mesh_leaf->indices = realloc(
    metil_mesh_leaf->indices,
    sizeof(unsigned int) *
    metil_mesh_leaf->length_indices
  );

  unsigned short int index_vertex = (
    0
  );

  unsigned short int index_index = (
    0
  );

  for (
    unsigned char index_radial_segment = 0;
    index_radial_segment < length_segments_radial;
    ++index_radial_segment
  ) {
    metil_mesh_leaf->indices[
      index_index
    ] = (
      0
    );

    metil_mesh_leaf->indices[
      index_index +
      1
    ] = (
      index_radial_segment +
      1
    );

    if (
      index_radial_segment != (
        length_segments_radial -
        1
      )
    ) {
      metil_mesh_leaf->indices[
        index_index +
        2
      ] = (
        index_radial_segment +
        2
      );
    } else {
      metil_mesh_leaf->indices[
        index_index +
        2
      ] = (
        1
      );
    }

    index_index = (
      index_index +
      3
    );
  }

  for (
    unsigned short int index_vertex_stem = 0;
    index_vertex_stem < length_vertices_stem;
    ++index_vertex_stem
  ) {
    unsigned char index_segment = (
      0
    );

    unsigned char index_radial_segment = (
      (
        index_vertex_stem -
        1
      ) % (
        length_segments_radial
      )
    );

    if (
      index_vertex_stem > 0
    ) {
      index_segment = (
        (
          index_vertex_stem -
          1
        ) /
        length_segments_radial
      );
    }

    if (
      index_vertex_stem == 0
    ) {
      metil_mesh_leaf->vertices[
        index_vertex
      ].x = (
        0.0f
      );

      metil_mesh_leaf->vertices[
        index_vertex
      ].y = (
        0.0f
      );

      metil_mesh_leaf->vertices[
        index_vertex
      ].z = (
        0.0f
      );

      continue;
    } else if (
      index_vertex_stem == (
        length_vertices_stem -
        1
      )
    ) {
      metil_mesh_leaf->vertices[
        index_vertex
      ].x = (
        0.0f
      );

      metil_mesh_leaf->vertices[
        index_vertex
      ].y = (
        (float) index_segment *
        height_stem_segment
      );

      metil_mesh_leaf->vertices[
        index_vertex
      ].z = (
        0.0f
      );
    } else {
      float angle = (
        (float) (
          index_radial_segment
        ) /
        (float) (length_segments_radial - 1) *
        M_PI *
        2.0f
      );

      metil_mesh_leaf->vertices[
        index_vertex
      ].x = (
        cos(
          angle
        ) *
        radius_stem.x
      );

      metil_mesh_leaf->vertices[
        index_vertex
      ].y = (
        (float) index_segment *
        height_stem_segment
      );

      metil_mesh_leaf->vertices[
        index_vertex
      ].z = (
        sin(
          angle
        ) *
        radius_stem.y
      );
    }

    metil_mesh_leaf->vertices[
      index_vertex
    ].w = (
      1.0f
    );

    index_vertex = (
      index_vertex +
      1
    );

    if (
      index_segment != (
        length_segments_stem +
        1
      )
    ) {
      metil_mesh_leaf->indices[
        index_index
      ] = (
        index_vertex
      );

      metil_mesh_leaf->indices[
        index_index +
        1
      ] = (
        index_vertex +
        length_segments_radial
      );

      if (
        (
          (
            index_vertex -
            1
          ) %
          length_segments_radial
        ) != (
          length_segments_radial -
          1
        )
      ) {
        metil_mesh_leaf->indices[
          index_index +
          2
        ] = (
          index_vertex +
          1
        );
      } else {
        metil_mesh_leaf->indices[
          index_index +
          2
        ] = (
          index_vertex -
          length_segments_radial +
          1
        );
      }

      index_index = (
        index_index +
        3
      );

      metil_mesh_leaf->indices[
        index_index
      ] = (
        index_vertex +
        length_segments_radial
      );

      if (
        (
          (
            index_vertex -
            1
          ) %
          length_segments_radial
        ) != (
          length_segments_radial -
          1
        )
      ) {
        metil_mesh_leaf->indices[
          index_index +
          1
        ] = (
          index_vertex +
          length_segments_radial +
          1
        );

        metil_mesh_leaf->indices[
          index_index +
          2
        ] = (
          index_vertex +
          1
        );
      } else {
        metil_mesh_leaf->indices[
          index_index +
          1
        ] = (
          index_vertex +
          1
        );

        metil_mesh_leaf->indices[
          index_index +
          2
        ] = (
          index_vertex -
          length_segments_radial +
          1
        );
      }

      index_index = (
        index_index +
        3
      );
    }
  }

  for (
    unsigned char index_radial_segment = 0;
    index_radial_segment < length_segments_radial;
    ++index_radial_segment
  ) {
    metil_mesh_leaf->indices[
      index_index
    ] = (
      index_vertex -
      1
    );

    metil_mesh_leaf->indices[
      index_index +
      1
    ] = (
      index_vertex -
      2 -
      index_radial_segment
    );

    if (
      index_radial_segment == (
        length_segments_radial
      )
    ) {
      metil_mesh_leaf->indices[
        index_index +
        2
      ] = (
        index_vertex -
        2
      );
    } else {
      metil_mesh_leaf->indices[
        index_index +
        2
      ] = (
        index_vertex -
        3 -
        index_radial_segment
      );
    }

    index_index = (
      index_index +
      3
    );
  }
}

/*

  /|
 /  \
/ |  \
|  | |
\  | /
 \|/
  |
  |

*/
