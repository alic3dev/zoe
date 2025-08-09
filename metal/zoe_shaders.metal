#include <metal_kit_shader_types.h>

#include <metal_stdlib>

struct data_rasterizer {
  float4 position [[position]];
  float point_size [[point_size]];
  float2 position_texture;
  uint id;
};

struct data_index_mesh {
  uint id;
};

vertex data_rasterizer zoe_shader_vertex(
  const device vector_float4* positions [[buffer(metal_kit_vertex_input_index_positions)]],
  constant metal_kit_data_frame& data_frame [[buffer(metal_kit_vertex_input_index_frame_data)]],
  constant data_index_mesh& index_mesh [[buffer(metal_kit_vertex_input_index_mesh_index)]],
  uint id_vertex [[vertex_id]]
) {
  data_rasterizer out;

  out.position = data_frame.objects[index_mesh.id].view_model_matrix_projection * positions[id_vertex];

  out.position_texture = float2(
    positions[id_vertex].x > 0.0f ? 1.0f : 0.0f,
    positions[id_vertex].y > 0.0f ? 1.0f : 0.0f
  );

  out.id = index_mesh.id;
  out.point_size = 10.0f;

  return out;
}

fragment float4 zoe_shader_fragment(
  data_rasterizer in [[stage_in]],
  metal::texture2d<half> texture [[ texture(1) ]]
) {
  float prog = ((float) in.id) / 343.0f;

  return float4(
    prog < 0.3f ? (
      prog < 0.15f ? prog / 0.15f : (0.3f - prog) / 0.15f
    ) : 0.0f,
    prog > 0.3f && prog < 0.6f ? (
      (prog < 0.45f ? (
        (prog - 0.3f) / 0.15f
      ) : (
        (0.6f - prog) / 0.15f
      ))
    ) : 0.0f,
    prog > 0.6f ? (
      (prog < 0.75f ? (
        (prog - 0.6f) / 0.15f
      ) : (
        (1.0f - prog) / 0.15f
      ))
    ) : 0.0f,
    1.0f
  );
  
  constexpr metal::sampler sampler_texture (
    metal::mag_filter::linear,
    metal::min_filter::linear
  );

  return float4(texture.sample(
    sampler_texture,
    in.position_texture
  ));
}
