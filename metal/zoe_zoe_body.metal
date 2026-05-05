#include <zoe_data/zoe_data_metal_player.h>
#include <zoe_metal/effects/zoe_metal_effect_damaged.h>
#include <zoe_metal/effects/zoe_metal_effect_shakiness.h>

#include <metil_metal/metil_metal_model_object.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_model_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

struct data_vertex {
  float4 position [[position]];
  float2 position_texture;
  float4 colour;
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
  constant struct zoe_data_metal_player* zoe_data_metal_player [[
    buffer(
      metil_renderer_vertex_index_parameter_joints +
      0x01
    )
  ]],
  unsigned int index_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  float4 position_vertex = (
    metil_model_object_position_calculate(
      index_vertex,
      &vertices[
        index_vertex
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

  float percentage_health = (
    (float)
    (
      (
        zoe_data_metal_player->health ==
        zoe_data_metal_player->health_maximum
      )
      ? zoe_data_metal_player->health
      : (
        zoe_data_metal_player->health -
        0x01
      )
    ) /
    (float)
    zoe_data_metal_player->health_maximum
  );

  data_vertex.colour.x = (
    (      (        0x03 +
        index_vertex
      ) %
      0x04    ) <
    0x02  );

  data_vertex.colour.y = (
    data_vertex.colour.x *
    percentage_health
  );

  data_vertex.colour.z = (
    data_vertex.colour.y *
    percentage_health
  );

  data_vertex.colour.w = (
    0x01
  );

  data_vertex.brightness = (
    data_frame->brightness
  );

  return (
    data_vertex
  );
}

fragment float4 zoe_zoe_body_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return (
    data_vertex.colour
  );
}
