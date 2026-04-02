#include <zoe_metal/zoe_shakiness.h>

#include <metil_metal/metil_metal_model_object.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_model_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float brightness;
};

[[vertex]] struct data_vertex zoe_zoe_body_vertex(
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
    metil_model_object_position_calculate(
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
    vertices[
      id_vertex
    ]
  );

  data_vertex.brightness = (
    data_frame->brightness
  );

  return data_vertex;
}

fragment float4 zoe_zoe_body_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return float4(
    1.0f,
    1.0f,
    1.0f,
    1.0f
  );
}
