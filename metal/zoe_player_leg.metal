#include <zoe_metal/zoe_shakiness.h>

#include <mesh/mesh_player.h>
#include <mesh/mesh_player_leg.h>

#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metil_metal/metil_metal_model_object.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_model_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float brightness;
  float4 colour;
};

[[vertex]] struct data_vertex zoe_player_leg_vertex(
  const device simd_float4* vertices [[
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

  float4 position_vertex = (
    metil_model_object_position_calcluate(
      id_vertex,
      &vertices[
        id_vertex
      ],
      &data_object->position,
      vertex_joint_map,
      joints
    )
  );

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    (
      position_vertex
    )
  );

  unsigned char index_segment_y = (
    (
      metal::max(
        (unsigned int) id_vertex,
        (unsigned int) 1
      ) -
      1
    ) /
    mesh_player_leg_segments_x
  );

  data_vertex.brightness = (
    data_frame->brightness *
    (
      1.0f -
      (
        0.7f *
        (
          (float) index_segment_y /
          mesh_player_leg_segments_y
        )
      )
    )
  );

  data_vertex.colour = (
    zoe_shakiness_get(
      data_frame->time_elapsed,
      (id_vertex + 1) * 13,
      333,
      1.3f
    )
  );

  float sine_frame = (
    math_c_sine(
      data_frame->frame,
      math_c_pi
    )
  );

  data_vertex.position_texture.x = (
    vertices[
      id_vertex
    ].x +
    vertices[
      id_vertex
    ].y +
    sine_frame
  );

  data_vertex.position_texture.y = (
    vertices[
      id_vertex
    ].z +
    sine_frame
  );

  return data_vertex;
}

fragment float4 zoe_player_leg_fragment(
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

  return float4(
    (
      texture_colour.r >= 0.98f
      ? texture_colour.r * data_vertex.colour.r * data_vertex.brightness
      : 0.0f
    ),
    (
      texture_colour.g >= 0.98f
      ? texture_colour.g * data_vertex.colour.g * data_vertex.brightness
      : 0.0f
    ),
    (
      texture_colour.b >= 0.98f
      ? texture_colour.b * data_vertex.colour.b * data_vertex.brightness
      : 0.0f
    ),
    mesh_player_colour_a
  );
}
