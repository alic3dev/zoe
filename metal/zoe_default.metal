#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float brightness;
};

[[vertex]] struct data_vertex zoe_default_vertex(
  const device simd_float4* positions [[
    buffer(
      metil_renderer_vertex_index_parameter_positions
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
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = data_object->view_model_matrix_projection * positions[id_vertex];

  data_vertex.position_texture.x = id_vertex % 2;
  data_vertex.position_texture.y = id_vertex % 2;

  data_vertex.brightness = data_frame->brightness;

  return data_vertex;
}

#if target_os_ios
fragment float4 zoe_default_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return float4(
    data_vertex.brightness,
    data_vertex.brightness,
    data_vertex.brightness,
    1.0f
  );
}
#else
fragment float4 zoe_default_fragment(
  struct data_vertex data_vertex [[stage_in]],
  metal::texture2d<half> texture [[ texture(0) ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  float4 texture_color = float4(
    texture.sample(
      sampler_texture,
      data_vertex.position_texture
    )
  );

  return float4(
    texture_color[0] * data_vertex.brightness,
    texture_color[1] * data_vertex.brightness,
    texture_color[2] * data_vertex.brightness,
    texture_color[3]
  );
}
#endif
