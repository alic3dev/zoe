#include <metal_kit_shader_types.h>

#include <metal_stdlib>

struct data_rasterizer {
  float4 position [[position]];
  float height;
  float2 position_texture;
  unsigned int id;
  unsigned int id_texture [[user(id_texture)]];
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
      ((float)data_frame.frame / 5000.0f) + (positions[id_vertex].x + (object.width / 2.0f)) / (object.width / 10.0f) + (positions[id_vertex].y + (object.height / 2.0f)) / (object.height / 10.0f),
      ((float)data_frame.frame / 5000.0f) + (positions[id_vertex].z + (object.depth / 2.0f)) / (object.depth / 10.0f) + (positions[id_vertex].y + (object.height / 2.0f)) / (object.height / 10.0f)
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

    if (positions[id_vertex].y <= object.height / 20.0f) {
      out.height = positions[id_vertex].y / (object.height / 20.0f) * 0.5f;
    } else {
      out.height = positions[id_vertex].y / object.height;
    }

    out.id_texture = 0;
  } else {
    out.id_texture = 1;
    out.height = positions[id_vertex].y / object.height;

    out.position_texture.y = id_vertex % 20 < 10 ? 1.0f : 0.0f;
    out.position_texture.x = metal::fabs(positions[id_vertex].x + positions[id_vertex].z) / (object.width * 2.0f);
  }

  out.id = index_mesh.id;

  out.noise = (float)(object.noise % 10000) / 10000.0f;

  return out;
}

fragment float4 zoe_shader_fragment(
  data_rasterizer in [[stage_in]],
  metal::texture2d<half> texture_ground [[ texture(0) ]],
  metal::texture2d<half> texture_tree [[ texture(1) ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  float4 texture_color = float4(
    (in.id_texture == 0
      ? texture_ground
      : texture_tree
    ).sample(
      sampler_texture,
      in.position_texture
    )
  );

  float brightness;

  if (in.id == length_objects_xyz - 1) {
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
