#include <mesh/mesh_player_head.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float brightness;
};

[[vertex]] struct data_vertex zoe_player_head_vertex(
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
    positions[id_vertex]
  );

  data_vertex.brightness = (
    (
      (
        1.0f - (
          (float) id_vertex /
          (float) mesh_player_head_segments_total
        )
      ) *
      0.5f +
      0.5f
    ) *
    data_frame->brightness
  );

  return data_vertex;
}

fragment float4 zoe_player_head_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return float4(
    0.02f * data_vertex.brightness,
    0.019f * data_vertex.brightness,
    0.04f * data_vertex.brightness,
    1.0f
  );
}
