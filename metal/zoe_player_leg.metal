#include <mesh/mesh_player.h>
#include <mesh/mesh_player_leg.h>

#include <metil_metal/metil_metal_model_object.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_model_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float brightness;
};

[[vertex]] struct data_vertex zoe_player_leg_vertex(
  const device simd_float4* vertices [[
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

  float4 position_vertex = (
    metil_model_object_position_calcluate(
      id_vertex,
      &vertices[
        id_vertex
      ],
      &data_object->position,
      vertex_joint_map,
      joints
    )
  );

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    position_vertex
  );

  unsigned char index_segment_y = (
    (
      metal::max(
        (unsigned int) id_vertex,
        (unsigned int) 1
      ) -
      1
    ) /
    mesh_player_leg_segments_x
  );

  data_vertex.brightness = (
    data_frame->brightness *
    (
      1.0f -
      (
        0.7f *
        (
          (float) index_segment_y /
          mesh_player_leg_segments_y
        )
      )
    )
  );

  return data_vertex;
}

fragment float4 zoe_player_leg_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return float4(
    mesh_player_color_r * data_vertex.brightness,
    mesh_player_color_g * data_vertex.brightness,
    mesh_player_color_b * data_vertex.brightness,
    mesh_player_color_a
  );
}
