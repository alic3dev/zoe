#include <mesh/zoe_mesh_auop.h>
#include <mesh/mesh_tree.h>
#include <zoe_metal/zoe_wave.h>

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
  unsigned int index_vertex;
  float distance;
  float brightness;
};

[[vertex]] struct data_vertex zoe_auop_vertex(
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
      zoe_wave_get(
        data_frame->time_elapsed,
        index_vertex,
        0xff,
        0x01
      )
    )
  );

  data_vertex.index_vertex = (
    index_vertex
  );

  data_vertex.brightness = (
    0x01 -
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

  return (
    data_vertex
  );
}

fragment float4 zoe_auop_fragment(
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
    ) *
    0.125f
  );

  float4 colour;

  if (
    data_vertex.index_vertex > 0xc8 &&
    data_vertex.index_vertex < 0xe1 &&
    (
(      ((data_vertex.index_vertex + 0x01) % zoe_mesh_auop_length_segment_vertices_radial) < 0x0a &&
      ((data_vertex.index_vertex + 0x01) % zoe_mesh_auop_length_segment_vertices_radial) > 0x06)
    )
  ) {
    colour = (
      float4(
        0xff,
        0xff,
        0x00,
        0x01
      )
    );
  } else {
    colour = (
      float4(
        data_vertex.brightness,
        data_vertex.brightness,
        data_vertex.brightness,
        0x01
      )
    );
  }

  metil_metal_colours_float4_brightness_apply(
    &colour,
    brightness
  );

  return (
    colour
  );
}
