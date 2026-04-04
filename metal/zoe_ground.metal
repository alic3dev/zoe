#include <zoe_metal/zoe_wave.h>

#include <math_c_bound.h>
#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>
#include <math_c_vector_distance.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

struct data_vertex {
  float4 position [[position]];
  float distance;
  float brightness;
};

[[vertex]] struct data_vertex zoe_ground_vertex(
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
        0x0bb8,
        1.1f
      )
    )
  );

  data_vertex.brightness = (
    data_frame->brightness
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
    math_c_vector3_distance_float(
      &position_raw,
      &position_player
    )
  );

  return (
    data_vertex
  );
}

fragment float4 zoe_ground_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  float brightness = (
    math_c_bound_float(
      (
        0x01 -
        (
          data_vertex.distance /
          1000.0f
        )
      ),
      0x01,
      0x00
    ) *
    data_vertex.brightness
  );

  return float4(
    brightness,
    brightness,
    brightness,
    0x01
  );
}
