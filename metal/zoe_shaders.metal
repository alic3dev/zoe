#include <metal_kit_shader_types.h>

#include <metal_stdlib>

struct data_rasterizer {
  float4 position [[position]];
  float distance;
  float height;
  float2 position_texture;
  unsigned char mode_texture;
  unsigned char index_texture;
  float noise;
  float brightness;
  float brightness_text;
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
  out.noise = (float)(data.noise % 10001) / 10000.0f;

  if (
    data.mode_texture == mode_texture_ground
  ) {
    float3 size_half;
    size_half.x = (data.width / 2.0f);
    size_half.y = (data.height / 2.0f);
    size_half.z = (data.depth / 2.0f);

    if (
      (
        (positions[id_vertex].x + size_half.x) < data.width * 0.12f ||
        (positions[id_vertex].x + size_half.x) > data.width * 0.88f
      ) || (
        (positions[id_vertex].z + size_half.z) < data.depth * 0.12f ||
        (positions[id_vertex].z + size_half.z) > data.depth * 0.88f
      )
    ) {
      out.index_texture = 1;
      out.position_texture = float2(
        ((float) data_frame.frame / 5000.0f) + (positions[id_vertex].x + size_half.x) / (data.width / 50.0f) + (positions[id_vertex].y + size_half.y) / (data.height / 50.0f),
        ((float) data_frame.frame / 5000.0f) + (positions[id_vertex].z + size_half.z) / (data.depth / 50.0f) + (positions[id_vertex].y + size_half.y) / (data.height / 50.0f)
      );
    } else {
      out.index_texture = 0;
      out.position_texture = float2(
        (id_vertex / 10) % 10 == 0 
        ? ((float) data_frame.frame / 100000.0f) + (positions[id_vertex].x + size_half.x) / (data.width / 1.0f) + (positions[id_vertex].y + size_half.y) / (data.height / 5.0f)
        : ((float) data_frame.frame / 100000.0f) + (positions[id_vertex].x + size_half.x) / (data.width / 500.0f) + (positions[id_vertex].y + size_half.y) / (data.height / 500.0f),
        (id_vertex / 10) % 10 == 0 
        ? ((float) data_frame.frame / 100000.0f) + (positions[id_vertex].z + size_half.z) / (data.depth / 1.0f) + (positions[id_vertex].y + size_half.y) / (data.height / 5.0f)
        : ((float) data_frame.frame / 100000.0f) + (positions[id_vertex].z + size_half.z) / (data.depth / 500.0f) + (positions[id_vertex].y + size_half.y) / (data.height / 500.0f)
      );
    }

    unsigned char z = 0;
    unsigned char x = 0;

    while (out.position_texture.x > 1.0f) {
      out.position_texture.x = (
        out.position_texture.x - 1.0f
      );

      z = z == 0 ? 1 : 0;
    }

    while (out.position_texture.y > 1.0f) {
      out.position_texture.y = (
        out.position_texture.y - 1.0f
      );

      x = x == 0 ? 1 : 0;
    }

    if (z == 1) {
      out.position_texture.x = 1.0f - (
        out.position_texture.x
      );
    }

    if (x == 1) {
      out.position_texture.y = 1.0f - (
        out.position_texture.y
      );
    }

    if (positions[id_vertex].y <= data.height / 20.0f) {
      out.height = positions[id_vertex].y / (data.height / 20.0f) * 0.5f;
    } else {
      out.height = (positions[id_vertex].y / data.height) * 0.4;
    }
  } else if (
    data.mode_texture == mode_texture_player
  ) {
    out.index_texture = 0;

    if (id_vertex == 0) {
      out.position_texture.x = 0.5f;
      out.position_texture.y = metal::fabs(1.0f - (float)(data_frame.frame % 221) / 110.0f);
    } else {
      out.position_texture.x = (float) ((id_vertex - 1)) / 6.0f;
      
      if (out.position_texture.x > 1.0f) {
        out.position_texture.x = 1.0f - (out.position_texture.x - 1.0f);
      }

      out.position_texture.y = metal::fabs(((float)(data_frame.frame % 667) / 333.0f) - 1.0f);
    }
  } else if (
    data.mode_texture == mode_texture_text
  ) {
    out.index_texture = 0;

    out.position_texture.x = (
      id_vertex == 0 || id_vertex == 3
      ? 0
      : 1
    );

    out.position_texture.y = (
      id_vertex == 0 || id_vertex == 1
      ? 1
      : 0
    );
  } else {
    out.index_texture = 0;
    out.height = positions[id_vertex].y / data.height;

    if (positions[id_vertex].x > data.width || positions[id_vertex].z > data.depth) {
      out.height = metal::fmin(positions[id_vertex].y / data.height * 0.2f, 0.2f);
      out.position_texture.y = id_vertex % 2 == 0 ? 1.0f : 0.0f;
      out.position_texture.x = (float)((unsigned short int)(metal::fabs(positions[id_vertex].x + positions[id_vertex].z) * 10000.0f) % 74) / 74.0f;
    } else {
      out.height = metal::fmin(positions[id_vertex].y / data.height * 0.8, 0.2f);
      out.position_texture.y = id_vertex % 20 < 10 ? 1.0f : 0.0f;
      out.position_texture.x = metal::fabs(positions[id_vertex].x + positions[id_vertex].z) / (data.width * 2.0f);
    }
  }

  out.distance = (
    metal::fabs((data.position.x + positions[id_vertex].x) + data_frame.position_player.x) + 
    metal::fabs((data.position.y + positions[id_vertex].y) + data_frame.position_player.y) + 
    metal::fabs((data.position.z + positions[id_vertex].z) + data_frame.position_player.z)
  );

  out.brightness = data_frame.brightness;
  out.brightness_text = data_frame.brightness_text;

  return out;
}

fragment float4 zoe_shader_fragment(
  data_rasterizer in [[stage_in]],
  metal::texture2d<half> texture [[ texture(0) ]],
  metal::texture2d<half> texture_two [[ texture(1) ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  float4 texture_color = float4(
    (
      in.index_texture == 0
      ? texture
      : texture_two
    ).sample(
      sampler_texture,
      in.position_texture
    )
  );

  float brightness = in.brightness;

  if (in.mode_texture == mode_texture_text) {
    return float4(
      texture_color[0] * in.noise * in.brightness_text,
      texture_color[1] * in.noise * in.brightness_text,
      texture_color[2] * in.noise * in.brightness_text,
      texture_color[3]
    );
  } else if (in.mode_texture == mode_texture_player) {
    return float4(
      texture_color[0] * brightness * 0.02f,
      texture_color[1] * brightness * 0.019f,
      texture_color[2] * brightness * 0.02f,
      texture_color[3]
    );
  } else {
    if (in.mode_texture == mode_texture_ground) {
      brightness = ((in.height * 0.8f) + 0.075f) * brightness;
    } else {
      brightness = ((in.height * 0.8f) + 0.075f) * (brightness * 0.8f);
    }

    brightness = brightness * metal::fmax(
      metal::fmin(
        100.0f / in.distance,
        1.0f
      ),
      0.0f
    );
  }

  return float4(
    texture_color[0] * brightness,
    texture_color[1] * brightness,
    texture_color[2] * brightness,
    texture_color[3]
  );
}
