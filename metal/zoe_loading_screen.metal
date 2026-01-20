#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float4 colour;
  float brightness;
};

[[vertex]] struct data_vertex zoe_loading_screen_vertex(
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

  data_vertex.brightness = (
    data_frame->brightness
  );

  float progress = (
    (float) data_object->noise /
    10000.0f
  );

  data_vertex.colour.x = (
    (
      progress < 0.3f
      ? progress
      : 0.0f
    ) / 0.3f
  );

  data_vertex.colour.y = (
    (
      (progress < 0.6f)
      ? progress - 0.3f
      : 0.0f
    ) / 0.3f
  );

  data_vertex.colour.z = (
    (
      (progress >= 0.6f)
      ? progress - 0.6f
      : 0.0f
    ) / 0.4f
  );

  data_vertex.colour.w = (
    1.0f
  );

  return data_vertex;
}

[[fragment]] float4 zoe_loading_screen_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return float4(
    (
      data_vertex.colour.x *
      data_vertex.brightness
    ),
    (
      data_vertex.colour.y *
      data_vertex.brightness
    ),
    (
      data_vertex.colour.z *
      data_vertex.brightness
    ),
    data_vertex.colour.w
  );
}
