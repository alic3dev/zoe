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
  unsigned int index_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    (
      positions[
        index_vertex
      ] +
      (
        index_vertex >= zoe_mesh_tree_length_vertices_trunk
        ? (
          zoe_wave_get(
            data_frame->time_elapsed,
            (
              index_vertex *
              3 +
              data_object->noise
            ),
            (
              (float)
              (
                index_vertex %
                5 +
                1
              ) /
              5.0f *
              1050.0f
            ),
            (
              (float)
              (
                index_vertex %
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
              index_vertex +
              data_object->noise
            ),
            511.4f,
            (
              (float)
              index_vertex /
              (float)
              zoe_mesh_tree_length_vertices_trunk
            ) * 0.464
          )
        )
      )
    )
  );

  data_vertex.brightness = (
    data_frame->brightness *
    (
      (
        (
          index_vertex %
          0x03
        ) >
        0x01
      )
      ? (
        (
          positions[
            index_vertex
          ].y <=
          2.0f
        )
        ? (
          1.0f -
          (
            positions[
              index_vertex
            ].y /
            2.0f *
            0.1f
          )
        )
        : (
          0.90f -
          (
            (float)
            (
              index_vertex %
              5
            ) /
            5.0f
          )
        )
      )
      : 1.0f
    )
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
      data_frame->frame,
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

  if (
    data_object->noise % 2 == 1
  ) {
    data_vertex.position_texture = (
      (
        data_vertex.position_texture
      ) /
      100000.0f
    );
  }

  return data_vertex;
}

fragment float4 zoe_tree_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  float brightness = metal::fmin(
    metal::fmax(
      1.0f - data_vertex.distance / 1000.0f,
      0.0f
    ),
    1.0f
  );

  return float4(
    brightness * data_vertex.brightness,
    brightness * data_vertex.brightness,
    brightness * data_vertex.brightness,
    1.0f
  );
}
