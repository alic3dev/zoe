#include <metal_kit_shader_types.h>

#include <metal_stdlib>

#include <clic3_vector.h>

struct data_rasterizer {
  float4 position [[position]];
  float height;
  float2 position_texture;
  unsigned char mode_texture;
  float noise;
};

vertex data_rasterizer zoe_shader_vertex(
  const device simd_float4* positions [[buffer(metal_kit_vertex_input_index_positions)]],
  constant metal_kit_data_frame& data_frame [[buffer(metal_kit_vertex_input_index_frame_data)]],
  constant metal_kit_data_frame_object& data [[buffer(metal_kit_vertex_input_index_data)]],
  unsigned int id_vertex [[vertex_id]]
) {
  data_rasterizer out;

  out.position = data.view_model_matrix_projection * positions[id_vertex];
  out.height = 0.0f;
  out.mode_texture = data.mode_texture;
  out.noise = (float)(data.noise % 10000) / 10000.0f;

  if (
    data.mode_texture == mode_texture_ground
  ) {
    out.position_texture = float2(
      ((float)data_frame.frame / 5000.0f) + (positions[id_vertex].x + (data.width / 2.0f)) / (data.width / 10.0f) + (positions[id_vertex].y + (data.height / 2.0f)) / (data.height / 10.0f),
      ((float)data_frame.frame / 5000.0f) + (positions[id_vertex].z + (data.depth / 2.0f)) / (data.depth / 10.0f) + (positions[id_vertex].y + (data.height / 2.0f)) / (data.height / 10.0f)
    );

    unsigned char z = 0;
    unsigned char x = 0;

    while (out.position_texture.x > 1.0f) {
      out.position_texture.x = (
        out.position_texture.x - 1.0f
      );
      z = z + 1;
    }

    while (out.position_texture.y > 1.0f) {
      out.position_texture.y = (
        out.position_texture.y - 1.0f
      );
      x = x + 1;
    }

    if (z % 2 != 0) {
      out.position_texture.x = 1.0f - (
        out.position_texture.x
      );
    }

    if (x % 2 != 0) {
      out.position_texture.y = 1.0f - (
        out.position_texture.y
      );
    }

    if (positions[id_vertex].y <= data.height / 20.0f) {
      out.height = positions[id_vertex].y / (data.height / 20.0f) * 0.5f;
    } else {
      out.height = positions[id_vertex].y / data.height;
    }
  } else {
    out.height = positions[id_vertex].y / data.height;

    

    if (positions[id_vertex].x > data.width || positions[id_vertex].z > data.depth) {
      out.position_texture.y = id_vertex % 2 == 0 ? 1.0f : 0.0f;
      out.position_texture.x = (float)((unsigned short int)(metal::fabs(positions[id_vertex].x + positions[id_vertex].z) * 10000.0f) % 74) / 74.0f;
    } else {
      out.position_texture.y = id_vertex % 20 < 10 ? 1.0f : 0.0f;
      out.position_texture.x = metal::fabs(positions[id_vertex].x + positions[id_vertex].z) / (data.width * 2.0f);
    }
  }

  return out;
}

fragment float4 zoe_shader_fragment(
  data_rasterizer in [[stage_in]],
  metal::texture2d<half> texture [[ texture(0) ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  float4 texture_color = float4(
    texture.sample(
      sampler_texture,
      in.position_texture
    )
  );

  float brightness;

  if (in.mode_texture == mode_texture_ground) {
    brightness = ((in.height * 0.8f) + 0.1f) * 0.1f;
  } else {
    brightness = ((in.height * 0.8f) + 0.5f) * 0.1f;
  }

  return float4(
    texture_color[0] * brightness,
    texture_color[1] * brightness,
    texture_color[2] * brightness,
    texture_color[3]
  );
}
