#include <zoe_mesh/attack_effects/zoe_mesh_attack_effect_slice.h>

#include <metil_mesh/metil_mesh.h>

void zoe_mesh_attack_effect_slice_initialize(
  struct metil_mesh* zoe_mesh_attack_effect_slice,
  unsigned int time
) {
  metil_mesh_initialize_with_lengths(
    zoe_mesh_attack_effect_slice,
    0x21,
    0x21
  );

  for (
    unsigned char index_vertex = (
      0x00
    );
    (
      index_vertex <
      zoe_mesh_attack_effect_slice->length_vertices
    );
    ++index_vertex
  ) {
    float progress = (
      (float)
      index_vertex /
      (float)
      (
        zoe_mesh_attack_effect_slice->length_vertices -
        0x01
      )
    );

    zoe_mesh_attack_effect_slice->vertices[
     index_vertex
    ].x = (
      (
        progress *
        0x02 -
        0x01
      ) *
      0x0a
    );

    zoe_mesh_attack_effect_slice->vertices[
      index_vertex
    ].y = (
      (
        progress *
        0x02 -
        0x01
      ) *
      0x02 +
      (
        (
          index_vertex +
          0x01
        ) %
        0x03
      )
    );

    zoe_mesh_attack_effect_slice->vertices[
      index_vertex
    ].z = (
      index_vertex %
      0x04 +
      (
        (
          progress > 0.5f
        ) ? 0x01 - (progress - 0.5f) / 0.5f : progress / 0.5f
      ) *
      0x0a
    );
  
    zoe_mesh_attack_effect_slice->vertices[
      index_vertex
    ].w = (
      0x01
    ); 
  }

  for (
    unsigned char index_index = (
      0x00
    );
    (
      index_index <
      zoe_mesh_attack_effect_slice->length_indices
    );
    ++index_index
  ) {
    zoe_mesh_attack_effect_slice->indices[
      index_index
    ] = (
      index_index
    );
  }
}

