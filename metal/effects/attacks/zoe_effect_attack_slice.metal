#include <zoe_data/zoe_data_attack_effect.h>

#include <metil_metal/metil_metal_data_vertex.h>
#include <metil_metal/metil_metal_colours.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

[[vertex]] struct data_vertex_basic_coloured zoe_effect_attack_slice_vertex(
  const device float4* vertices [[
    buffer(
      metil_renderer_vertex_index_parameter_vertices
    )
  ]],
  constant struct metil_renderer_data_frame* data_frame [[
    buffer(
      metil_renderer_vertex_index_parameter_data_frame
    )
  ]],
  constant struct metil_renderer_data_object* data_object [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  constant struct zoe_data_attack_effect* zoe_data_attack_effect [[
    buffer(
      zoe_data_attack_effect_buffer_index
    )
  ]],
  unsigned int index_vertex [[
    vertex_id
  ]]
) {
  struct data_vertex_basic_coloured data_vertex_basic_coloured;

  float percentage = (
    (float)
    (
      data_frame->time_elapsed -
      zoe_data_attack_effect->time_started
    ) /
    (float)
    zoe_data_attack_effect->length
  );

  float4 vertex_current = (
    vertices[
      index_vertex
    ]
  );

  vertex_current = (
    vertex_current +
    vertex_current *
    0.5f *
    percentage
  );

  vertex_current.w = (
    vertices[
      index_vertex
    ].w +
    0.25f *
    percentage
  );

  data_vertex_basic_coloured.position = (
    data_object->view_model_matrix_projection *
    vertex_current
  );

  data_vertex_basic_coloured.colour.x = (
    data_object->colour.x *
    (
      (float)
      (
        index_vertex %
        0x05
      ) /
      0x04
    ) *
    percentage *
    0.9f
  );

  data_vertex_basic_coloured.colour.y = (
    0x00
  );
 
  data_vertex_basic_coloured.colour.z = (
    0x00
  );

  data_vertex_basic_coloured.colour.w = (
    0x01 -
    (
      0x01 -
      percentage
    ) *
    0.4 +
    0.6
  );

  if (
    (
      (float)
      (
        index_vertex /
        0x03
      ) /
      (
        0x21 /
        0x03
      )
    ) >
    percentage *
    1.75f
  ) {
    data_vertex_basic_coloured.colour.w = (
      0x00
    );
  }
 
  return (
    data_vertex_basic_coloured
  );
}

[[fragment]] float4 zoe_effect_attack_slice_fragment(
  struct data_vertex_basic_coloured data_vertex_basic_coloured [[
    stage_in
  ]]
) {
  metil_metal_colours_float4_brightness_apply(
    &data_vertex_basic_coloured.colour,
    data_vertex_basic_coloured.brightness
  );

  return (
    data_vertex_basic_coloured.colour
  );
}
