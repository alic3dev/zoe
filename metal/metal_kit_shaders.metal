#include <metal_kit_shader_types.h>

struct data_rasterizer {
  float4 position [[position]];

  float3 color;
};

struct data_index_mesh {
  uint id;
};

vertex data_rasterizer shader_vertex(
  const device vector_float4* positions [[buffer(metal_kit_vertex_input_index_positions)]],
  constant metal_kit_data_frame& data_frame [[buffer(metal_kit_vertex_input_index_frame_data)]],
  constant data_index_mesh& index_mesh [[buffer(metal_kit_vertex_input_index_mesh_index)]],
  uint id_vertex [[vertex_id]]
) {
  data_rasterizer out;

  out.position = data_frame.objects[index_mesh.id].view_model_matrix_projection * positions[id_vertex];
  out.color = data_frame.objects[index_mesh.id].color;

  return out;
}

fragment float4 shader_fragment(data_rasterizer in [[stage_in]]) {
  return float4(in.color.rgb, 1.0f);
}
