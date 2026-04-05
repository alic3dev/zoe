#include <object/object_hill.h>

#include <math_c_bound.h>
#include <math_c_maximum.h>
#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metil_metal/metil_metal_colours.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

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
  metal::texture2d<float> texture [[ texture(0x00) ]],
  metal::texture2d<float> texture_secondary [[ texture(0x01) ]],
  metal::texture2d<float> texture_lighting [[ texture(0x02) ]]
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

  float4 texture_colour = (
    texture.sample(
      sampler_texture,
      data_vertex.position_texture /
      1000.0f
    )
  );

  float4 texture_secondary_colour = (
    texture.sample(
      sampler_texture_secondary,
      data_vertex.position_lighting
    )
  );

  float4 texture_sample_lighting = (
    texture_lighting.sample(
      sampler_texture_lighting,
      data_vertex.position_lighting
    )
  );

  uint2 size_texture = {
    uint2(
      texture_lighting.get_width(
        0x00
      ),
      texture_lighting.get_height(
        0x00
      )
    )
  };

  float4 val = (
    texture_lighting.read(
      size_texture
    )
  );

  float brightness_distance = (
    (
      1.0f -
      math_c_sine(
        (
          math_c_sine(
            (
              math_c_bound_float(
                (
                  data_vertex.distance /
                  1000.0f
                ),
                1.0f,
                0.0f
              ) *
              math_c_pi_half
            ),
            math_c_pi
          ) *
          math_c_pi_half
        ),
        math_c_pi
      )
    ) *
    0.01f
  );

  texture_sample_lighting.x = (
    math_c_maximum_float(
      texture_sample_lighting.x,
      brightness_distance
    )
  );

  texture_sample_lighting.y = (
    texture_sample_lighting.x
  );

  texture_sample_lighting.z = (
    texture_sample_lighting.y
  );

  float4 textures = (
    texture_colour *
    texture_secondary_colour *
    texture_sample_lighting
  );

  textures.w = (
    0x01
  ); 

  metil_metal_colours_float4_brightness_apply(
    &textures,
    data_vertex.brightness
  );

  return (
    textures
  );
}
