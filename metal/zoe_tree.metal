#include <mesh/mesh_tree.h>
#include <zoe_metal/zoe_wave.h>

#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float distance;
  float brightness;
};

[[vertex]] struct data_vertex zoe_tree_vertex(
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
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    (
      positions[
        id_vertex
      ] +
      (
        id_vertex >= zoe_mesh_tree_length_vertices_trunk
        ? (
          zoe_wave_get(
            data_frame->time_elapsed,
            (
              id_vertex *
              3 +
              data_object->noise
            ),
            (
              (float)
              (
                id_vertex %
                5 +
                1
              ) /
              5.0f *
              1050.0f
            ),
            (
              (float)
              (
                id_vertex %
                5 +
                1
              ) /
              5.0f *
              0.76
            )
          )
        )
        : (
          zoe_wave_get(
            data_frame->time_elapsed,
            (
              id_vertex +
              data_object->noise
            ),
            511.4f,
            (
              (float)
              id_vertex /
              (float)
              zoe_mesh_tree_length_vertices_trunk
            ) * 0.464
          )
        )
      )
    )
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
        id_vertex
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
      data_frame->frame,
      math_c_pi
    )
  );

  data_vertex.position_texture.x = (
    positions[
      id_vertex
    ].x +
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

fragment float4 zoe_tree_fragment(
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
      (
        data_vertex.position_texture *
        100.0f
      )
    )
  );

  float brightness = metal::fmin(
    metal::fmax(
      1.0f - data_vertex.distance / 1000.0f,
      0.0f
    ),
    1.0f
  );

  return float4(
    texture_colour.r * brightness * data_vertex.brightness,
    texture_colour.g * brightness * data_vertex.brightness,
    texture_colour.b * brightness * data_vertex.brightness,
    1.0f
  );
}
