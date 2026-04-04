#include <metil_metal/metil_metal_colours.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float brightness;
};

[[vertex]] struct data_vertex zoe_default_vertex(
  const device simd_float4* positions [[
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
  unsigned int index_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    positions[
      index_vertex
    ]
  );

  data_vertex.position_texture.x = (
    index_vertex %
    0x02
  );

  data_vertex.position_texture.y = (
    index_vertex %
    0x02
  );

  data_vertex.brightness = (
    data_frame->brightness
  );

  return (
    data_vertex
  );
}

fragment float4 zoe_default_fragment(
  struct data_vertex data_vertex [[ stage_in ]],
  metal::texture2d<float> texture [[ texture(0x00) ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  float4 texture_sample = (
    texture.sample(
      sampler_texture,
      data_vertex.position_texture
    )
  );

  metil_metal_colours_float4_brightness_apply(
    &texture_sample,
    data_vertex.brightness
  );

  return (
    texture_sample
  );
}
