#include <mode_texture.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
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

[[vertex]] struct data_vertex zoe_ground_vertex(
  const device simd_float4* positions [[
    buffer(
      metil_renderer_vertex_index_parameter_positions
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

  data_vertex.position = data_object->view_model_matrix_projection * positions[id_vertex];
  data_vertex.height = 0.0f;
  data_vertex.mode_texture = data_object->mode_texture;
  data_vertex.noise = (float)(data_object->noise % 10001) / 10000.0f;

  if (
    data_object->mode_texture == mode_texture_ground
  ) {
    float3 size_half;
    size_half.x = (data_object->width / 2.0f);
    size_half.y = (data_object->height / 2.0f);
    size_half.z = (data_object->depth / 2.0f);

    if (
      (
        (positions[id_vertex].x + size_half.x) < data_object->width * 0.12f ||
        (positions[id_vertex].x + size_half.x) > data_object->width * 0.88f
      ) || (
        (positions[id_vertex].z + size_half.z) < data_object->depth * 0.12f ||
        (positions[id_vertex].z + size_half.z) > data_object->depth * 0.88f
      )
    ) {
      data_vertex.index_texture = 1;
      data_vertex.position_texture = float2(
        ((float) data_frame->frame / 5000.0f) + (positions[id_vertex].x + size_half.x) / (data_object->width / 50.0f) + (positions[id_vertex].y + size_half.y) / (data_object->height / 50.0f),
        ((float) data_frame->frame / 5000.0f) + (positions[id_vertex].z + size_half.z) / (data_object->depth / 50.0f) + (positions[id_vertex].y + size_half.y) / (data_object->height / 50.0f)
      );
    } else {
      data_vertex.index_texture = 0;
      data_vertex.position_texture = float2(
        (id_vertex / 10) % 10 == 0 
        ? ((float) data_frame->frame / 100000.0f) + (positions[id_vertex].x + size_half.x) / (data_object->width / 1.0f) + (positions[id_vertex].y + size_half.y) / (data_object->height / 5.0f)
        : ((float) data_frame->frame / 100000.0f) + (positions[id_vertex].x + size_half.x) / (data_object->width / 500.0f) + (positions[id_vertex].y + size_half.y) / (data_object->height / 500.0f),
        (id_vertex / 10) % 10 == 0 
        ? ((float) data_frame->frame / 100000.0f) + (positions[id_vertex].z + size_half.z) / (data_object->depth / 1.0f) + (positions[id_vertex].y + size_half.y) / (data_object->height / 5.0f)
        : ((float) data_frame->frame / 100000.0f) + (positions[id_vertex].z + size_half.z) / (data_object->depth / 500.0f) + (positions[id_vertex].y + size_half.y) / (data_object->height / 500.0f)
      );
    }

    unsigned char z = 0;
    unsigned char x = 0;

    while (data_vertex.position_texture.x > 1.0f) {
      data_vertex.position_texture.x = (
        data_vertex.position_texture.x - 1.0f
      );

      z = z == 0 ? 1 : 0;
    }

    while (data_vertex.position_texture.y > 1.0f) {
      data_vertex.position_texture.y = (
        data_vertex.position_texture.y - 1.0f
      );

      x = x == 0 ? 1 : 0;
    }

    if (z == 1) {
      data_vertex.position_texture.x = 1.0f - (
        data_vertex.position_texture.x
      );
    }

    if (x == 1) {
      data_vertex.position_texture.y = 1.0f - (
        data_vertex.position_texture.y
      );
    }

    if (positions[id_vertex].y <= data_object->height / 20.0f) {
      data_vertex.height = positions[id_vertex].y / (data_object->height / 20.0f) * 0.5f;
    } else {
      data_vertex.height = (positions[id_vertex].y / data_object->height) * 0.4;
    }
  }

  data_vertex.brightness = data_frame->brightness;
  data_vertex.brightness_text = data_frame->brightness_text;

  if (data_object->noise == 666) {
    data_vertex.distance = (
      metal::fabs((data_object->position.x + positions[id_vertex].x)) + 
      metal::fabs((data_object->position.y + positions[id_vertex].y) - 60.0f) + 
      metal::fabs((data_object->position.z + positions[id_vertex].z))
    );

    if (
      (data_object->position.x + positions[id_vertex].x) < 50 &&
      (data_object->position.x + positions[id_vertex].x) > -50 &&
      (data_object->position.z + positions[id_vertex].z) < 50 &&
      (data_object->position.z + positions[id_vertex].z) > -50
    ) {
      data_vertex.distance = data_vertex.distance * 5;
    } else {
      data_vertex.distance = data_vertex.distance * 7;
    }
    
    data_vertex.height = 1.0f;
  } else {
    data_vertex.distance = (
      metal::fabs((data_object->position.x + positions[id_vertex].x) + data_frame->position_player.x) + 
      metal::fabs((data_object->position.y + positions[id_vertex].y) + data_frame->position_player.y) + 
      metal::fabs((data_object->position.z + positions[id_vertex].z) + data_frame->position_player.z)
    );
  }

  return data_vertex;
}

fragment float4 zoe_ground_fragment(
  struct data_vertex data_vertex [[stage_in]],
  metal::texture2d<half> texture [[ texture(0) ]],
  metal::texture2d<half> texture_two [[ texture(1) ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  float4 texture_color = float4(
    (
      data_vertex.index_texture == 0
      ? texture
      : texture_two
    ).sample(
      sampler_texture,
      data_vertex.position_texture
    )
  );

  float brightness = data_vertex.brightness;

  brightness = ((data_vertex.height * 0.8f) + 0.075f) * brightness;

  brightness = brightness * metal::fmax(
    metal::fmin(
      100.0f / data_vertex.distance,
      1.0f
    ),
    0.0f
  );

  return float4(
    texture_color[0] * brightness,
    texture_color[1] * brightness,
    texture_color[2] * brightness,
    texture_color[3]
  );
}
