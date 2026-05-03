#include <metil_metal/metil_metal_data_vertex.h>
#include <metil_metal/metil_metal_colours.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

[[vertex]] struct data_vertex_basic_coloured zoe_effect_attack_slice_vertex(
) {
  struct data_vertex_basic_coloured data_vertex_basic_coloured;

  return (
    data_vertex_basic_coloured
  );
}

[[fragment]] float4 zoe_effect_attack_slice_fragment(
  struct data_vertex_basic_coloured data_vertex_basic_coloured [[stage_in]]
) {
  metil_metal_colours_float4_brightness_apply(
    &data_vertex_basic_coloured.colour,
    data_vertex_basic_coloured.brightness
  );

  return (
    data_vertex_basic_coloured.colour
  );
}
