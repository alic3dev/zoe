#include <zoe_data/zoe_data_enemy.h>
#include <zoe_mesh/zoe_mesh_auop.h>
#include <zoe_mesh/mesh_tree.h>
#include <zoe_metal/effects/zoe_metal_effect_damaged.h>
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

  unsigned int index_vertex;

  float distance;
  float brightness;

  unsigned int time_current;
  unsigned int time_damaged;
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
  constant struct zoe_data_enemy* zoe_data_enemy [[
    buffer(
      zoe_data_enemy_buffer_index_default_object
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
      zoe_metal_effect_wave_get(
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

  data_vertex.time_current = (
    data_frame->time_elapsed
  );

  data_vertex.time_damaged = (
    zoe_data_enemy->time_damaged
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
    (
      data_vertex.index_vertex >
      0xc8
    ) &&
    (
      data_vertex.index_vertex <
      0xe1
    ) &&
    (
      (
        (
          data_vertex.index_vertex +
          0x01
        ) %
        zoe_mesh_auop_length_segment_vertices_radial
      ) <
      0x0a
    )
 &&
    (
      (
        (
          data_vertex.index_vertex +
          0x01
        ) %
        zoe_mesh_auop_length_segment_vertices_radial
      ) >
      0x06
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

  zoe_metal_effect_damaged_apply_colours(
    &colour,
    data_vertex.time_current,
    data_vertex.time_damaged
  );

  return (
    colour
  );
}
