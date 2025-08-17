#include <metal_kit_shader_types.h>

#include <metal_stdlib>

struct data_rasterizer {
  float4 position [[position]];
  float height;
  float point_size [[point_size]];
  float2 position_texture;
  unsigned int id;
  float noise;
};

struct data_index_mesh {
  unsigned int id;
};

vertex data_rasterizer zoe_shader_vertex(
  const device vector_float4* positions [[buffer(metal_kit_vertex_input_index_positions)]],
  constant metal_kit_data_frame& data_frame [[buffer(metal_kit_vertex_input_index_frame_data)]],
  constant data_index_mesh& index_mesh [[buffer(metal_kit_vertex_input_index_mesh_index)]],
  unsigned int id_vertex [[vertex_id]]
) {
  data_rasterizer out;

  metal_kit_data_frame_object object = data_frame.objects[index_mesh.id];

  out.position = object.view_model_matrix_projection * positions[id_vertex];
  out.height = 0.0f;

  if (
    index_mesh.id == length_objects_xyz - 1
  ) {
    out.position_texture = float2(
      ((float)data_frame.frame / 1000.0f) + (positions[id_vertex].x + (object.width / 2.0f)) / (object.width / 10.0f) + (positions[id_vertex].y + (object.height / 2.0f)) / (object.height / 10.0f),
      ((float)data_frame.frame / 1000.0f) + (positions[id_vertex].z + (object.depth / 2.0f)) / (object.depth / 10.0f) + (positions[id_vertex].y + (object.height / 2.0f)) / (object.height / 10.0f)
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

    out.height = positions[id_vertex].y / object.height;
  } else {
    out.position_texture = float2(
      positions[id_vertex].x,
      positions[id_vertex].z
    );

    while (out.position_texture.x > 1.0f) {
      out.position_texture.x = (
        out.position_texture.x - 1.0f
      );
    }

    while (out.position_texture.y > 1.0f) {
      out.position_texture.y = (
        out.position_texture.y - 1.0f
      );
    }

    while (out.position_texture.x < 0.0f) {
      out.position_texture.x = (
        out.position_texture.x + 1.0f
      );
    }

    while (out.position_texture.y < 0.0f) {
      out.position_texture.y = (
        out.position_texture.y + 1.0f
      );
    }
  }

  out.id = index_mesh.id;
  out.point_size = 10.0f;

  out.noise = (float)(object.noise % 10000) / 10000.0f;

  return out;
}

fragment float4 zoe_shader_fragment(
  data_rasterizer in [[stage_in]],
  metal::texture2d<half> texture [[ texture(0) ]]
) {
  if (in.id == length_objects_xyz - 1) {
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

    float brightness = ((in.height * 0.8f) + 0.2f) * 0.1f;

    return float4(
      texture_color[0] * brightness,
      texture_color[1] * brightness,
      texture_color[2] * brightness,
      texture_color[3]
    );
  }

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

  float prog = in.noise;

  return float4(
    texture_color[0] * (prog < 0.3f ? (
      prog < 0.15f ? prog / 0.15f : (0.3f - prog) / 0.15f
    ) : 0.0f),
    texture_color[1] * (prog > 0.3f && prog < 0.6f ? (
      (prog < 0.45f ? (
        (prog - 0.3f) / 0.15f
      ) : (
        (0.6f - prog) / 0.15f
      ))
    ) : 0.0f),
    texture_color[2] * (prog > 0.6f ? (
      (prog < 0.75f ? (
        (prog - 0.6f) / 0.15f
      ) : (
        (1.0f - prog) / 0.15f
      ))
    ) : 0.0f),
    1.0f
  );
}
