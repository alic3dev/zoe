#include <object/object_hill.h>

#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float2 position_lighting;
  float distance;
  float brightness;
};

[[vertex]] struct data_vertex zoe_hill_vertex(
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
  constant struct zoe_data_object_hill* data_object [[
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

  data_vertex.brightness = (
    data_frame->brightness
  );

  data_vertex.distance = metal::distance(
    metal::float4(
      metal::float4(
        data_object->position.x,
        data_object->position.y,
        data_object->position.z,
        1.0f
      ) +
      positions[
        index_vertex
      ]
    ),
    metal::float4(
      data_frame->position_player.x,
      data_frame->position_player.y,
      data_frame->position_player.z,
      1.0f
    )
  );

  float sine_frame = (
    math_c_sine(
      (
        (float)
        data_frame->frame /
        1000.0f
      ),
      math_c_pi
    )
  );

  data_vertex.position_texture.x = (
    positions[
      index_vertex
    ].x +
    sine_frame
  );

  data_vertex.position_texture.y = (
    positions[
      index_vertex
    ].z +
    sine_frame
  );

  data_vertex.position_lighting.x = (
    0.0f +
    (
      positions[
        index_vertex
      ].x /
      data_object->size.x +
      0.5f
    )
  );

  data_vertex.position_lighting.y = (
    0.0f +
    (
      positions[
        index_vertex
      ].z /
      data_object->size.z +
      0.5f
    )
  ); 

  return (
    data_vertex
  );
}

fragment float4 zoe_hill_fragment(
  struct data_vertex data_vertex [[stage_in]],
  metal::texture2d<half> texture [[ texture(0x00) ]],
  metal::texture2d<half> texture_secondary [[ texture(0x01) ]],
  metal::texture2d<half> texture_lighting [[ texture(0x02) ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::t_address::repeat,
    metal::r_address::repeat,
    metal::s_address::repeat
  );

  constexpr metal::sampler sampler_texture_secondary(
    metal::mag_filter::nearest
  );

  constexpr metal::sampler sampler_texture_lighting(
    metal::mag_filter::linear
  );

  float4 texture_colour = float4(
    texture.sample(
      sampler_texture,
      data_vertex.position_texture / 1000.0f
    )
  );

  float4 texture_secondary_colour = (
    float4(
      texture.sample(
        sampler_texture_secondary,
        data_vertex.position_lighting
      )
    )
  );

  float4 texture_sample_lighting = (
    float4(
      texture_lighting.sample(
        sampler_texture_lighting,
        data_vertex.position_lighting
      )
    )
  );

  float brightness = metal::fmin(
    metal::fmax(
      1.0f - (
        data_vertex.distance /
        1000.0f
      ),
      0.0f
    ),
    1.0f
  );

  return float4(
    texture_colour.r * texture_secondary_colour.x * texture_sample_lighting.x * brightness * data_vertex.brightness,
    texture_colour.g * texture_secondary_colour.y * texture_sample_lighting.y * brightness * data_vertex.brightness,
    texture_colour.b * texture_secondary_colour.z * texture_sample_lighting.z * brightness * data_vertex.brightness,
    1.0f
  );
}
