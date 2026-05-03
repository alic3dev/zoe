#include <zoe_mesh/mesh_tree.h>
#include <zoe_metal/effects/zoe_metal_effect_wave.h>

#include <math_c_bound.h>
#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>
#include <math_c_vector_distance.h>

#include <metil_metal/metil_metal_colours.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

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
          zoe_metal_effect_wave_get(
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
          zoe_metal_effect_wave_get(
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

  struct math_c_vector3_float position_raw = {
    .x = (
      data_object->position.x +
      positions[
        index_vertex
      ].x
    ),
    .y = (
      data_object->position.y +
      positions[
        index_vertex
      ].y
    ),
    .z = (
      data_object->position.z +
      positions[
        index_vertex
      ].z
    )
  };

  struct math_c_vector3_float position_player = {
    .x = (
      data_frame->position_player.x
    ),
    .y = (
      data_frame->position_player.y
    ),
    .z = (
      data_frame->position_player.z
    )
  };
  data_vertex.distance = (
    math_c_vector3_distance_float_fastest(
      &position_player,
      &position_raw
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
    (
      data_object->noise %
      0x02
    ) ==
    0x01
  ) {
    data_vertex.position_texture = (
      data_vertex.position_texture /
      100000.0f
    );
  }

  return (
    data_vertex
  );
}

fragment float4 zoe_tree_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  float brightness = (
    math_c_bound_float(
      (
        1.0f -
        (
          data_vertex.distance /
          1000.0f
        )
      ),
      0x01,
      0x00
    )
  );

  float4 colour = (
    float4(
      data_vertex.brightness,
      data_vertex.brightness,
      data_vertex.brightness,
      0x01
    )
  );

  metil_metal_colours_float4_brightness_apply(
    &colour,
    brightness
  );

  return (
    colour
  );
}
