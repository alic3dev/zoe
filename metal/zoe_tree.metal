#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
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
    positions[
      id_vertex
    ]
  );

  data_vertex.brightness = data_frame->brightness;

  data_vertex.distance = metal::distance(
    metal::float4(
      metal::float4(
        data_object->position.x,
        data_object->position.y,
        data_object->position.z,
        1.0f
      ) +
      positions[id_vertex]
    ),
    metal::float4(
      data_frame->position_player.x,
      data_frame->position_player.y,
      data_frame->position_player.z,
      1.0f
    )
  );

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
    brightness,
    brightness,
    brightness,
    1.0f
  );
}
