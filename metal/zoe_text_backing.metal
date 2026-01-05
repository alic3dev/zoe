#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float4 color;
  float brightness;
};

[[vertex]] struct data_vertex zoe_text_backing_vertex(
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
    data_frame->brightness_text
  );

  data_vertex.color.x = (
    data_object->color.x
  );

  data_vertex.color.y = (
    data_object->color.y
  );

  data_vertex.color.z = (
    data_object->color.z
  );

  data_vertex.color.w = (
    data_object->color.w
  );

  return data_vertex;
}

[[fragment]] float4 zoe_text_backing_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return float4(
    (
      data_vertex.color.x *
      data_vertex.brightness
    ),
    (
      data_vertex.color.y *
      data_vertex.brightness
    ),
    (
      data_vertex.color.z *
      data_vertex.brightness
    ),
    (
      data_vertex.color.w *
      0.5f
    )
  );
}
