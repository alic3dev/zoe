#include <zoe_metal/zoe_shakiness.h>

#include <mesh/mesh_player.h>
#include <mesh/mesh_player_head.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_model_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float brightness;
  float4 colour;
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
    (
      positions[
        id_vertex
      ] +
      zoe_shakiness_get(
        data_frame->time_elapsed,
        (id_vertex + 1) * 13,
        333,
        1.3f
      )
    )
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

  data_vertex.colour = (
    zoe_shakiness_get(
      data_frame->time_elapsed,
      (id_vertex + 1) * 13,
      333,
      1.3f
    )
  );

  return data_vertex;
}

fragment float4 zoe_player_head_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return float4(
    data_vertex.colour.r * data_vertex.brightness,
    data_vertex.colour.g * data_vertex.brightness,
    data_vertex.colour.b * data_vertex.brightness,
    mesh_player_colour_a
  );
}
