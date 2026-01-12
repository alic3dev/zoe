#include <mesh/mesh_player.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_model_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
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
    positions[id_vertex]
  );

  data_vertex.brightness = (
    data_frame->brightness * (
      id_vertex == 0
      ? 1.0f
      : 0.2f
    )
  );

  return data_vertex;
}

fragment float4 zoe_player_body_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return float4(
    mesh_player_color_r * data_vertex.brightness,
    mesh_player_color_g * data_vertex.brightness,
    mesh_player_color_b * data_vertex.brightness,
    mesh_player_color_a
  );
}
