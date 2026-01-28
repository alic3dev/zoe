#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float3 colour;
  float brightness;
};

[[vertex]] struct data_vertex zoe_mushroom_vertex(
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

  if (
    id_vertex <= 5000
  ) {
    data_vertex.colour.r = 1.0f;
    data_vertex.colour.g = 0.0f;
    data_vertex.colour.b = 0.0f;

    if (
      id_vertex % 32 == 0 &&
      id_vertex >= 100
    ) {
      data_vertex.colour.g = 1.0f;
      data_vertex.colour.b = 1.0f;
    }
  } else {
    data_vertex.colour.r = 1.0f;
    data_vertex.colour.g = 1.0f;
    data_vertex.colour.b = 0.8f;
  }

  return (
    data_vertex
  );
}

fragment float4 zoe_mushroom_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return float4(
    data_vertex.colour.r * data_vertex.brightness,
    data_vertex.colour.g * data_vertex.brightness,
    data_vertex.colour.b * data_vertex.brightness,
    1.0f
  );
}
