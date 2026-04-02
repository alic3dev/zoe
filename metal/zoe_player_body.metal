#include <zoe_metal/zoe_shakiness.h>

#include <mesh/mesh_player.h>

#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_model_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float brightness;
};

[[vertex]] struct data_vertex zoe_player_body_vertex(
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
  constant struct metil_renderer_data_model_object* data_object [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  constant unsigned int* vertex_joint_map [[
    buffer(
      metil_renderer_vertex_index_parameter_vertex_joint_map
    )
  ]],
  constant struct math_c_vector3_float* joints [[
    buffer(
      metil_renderer_vertex_index_parameter_joints
    )
  ]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    (
      positions[
        id_vertex
      ]
    )
  );

  data_vertex.brightness = (
    data_frame->brightness * (
      id_vertex == 0
      ? 1.0f
      : 0.2f
    )
  );

  float sine_frame = (
    math_c_sine(
      data_frame->frame,
      math_c_pi
    )
  );

  data_vertex.position_texture.x = (
    positions[
      id_vertex
    ].x +
    positions[
      id_vertex
    ].y +
    sine_frame
  );

  data_vertex.position_texture.y = (
    positions[
      id_vertex
    ].z +
    sine_frame
  );

  return data_vertex;
}

fragment float4 zoe_player_body_fragment(
  struct data_vertex data_vertex [[stage_in]],
  metal::texture2d<half> texture [[ texture(0) ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::t_address::repeat,
    metal::r_address::repeat,
    metal::s_address::repeat
  );

  float4 texture_colour = float4(
    texture.sample(
      sampler_texture,
      data_vertex.position_texture
    )
  );

  if (
    texture_colour.r == texture_colour.g &&
    texture_colour.g == texture_colour.b
  ) {
    return float4(
      (
        texture_colour.r >= 0.99f
        ? texture_colour.r * mesh_player_colour_r * data_vertex.brightness * 0.1f
        : 0.0f
      ),
      (
        texture_colour.g >= 0.99f
        ? texture_colour.g * mesh_player_colour_g * data_vertex.brightness * 0.1f
        : 0.0f
      ),
      (
        texture_colour.b >= 0.99f
        ? texture_colour.b * mesh_player_colour_b * data_vertex.brightness * 0.1f
        : 0.0f
      ),
      mesh_player_colour_a
    );
  } else {
    return float4(
      (
        texture_colour.r >= 0.99f
        ? texture_colour.r * mesh_player_colour_r * data_vertex.brightness
        : 0.0f
      ),
      (
        texture_colour.g >= 0.99f
        ? texture_colour.g * mesh_player_colour_g * data_vertex.brightness
        : 0.0f
      ),
      (
        texture_colour.b >= 0.99f
        ? texture_colour.b * mesh_player_colour_b * data_vertex.brightness
        : 0.0f
      ),
      mesh_player_colour_a
    );
  }
}
