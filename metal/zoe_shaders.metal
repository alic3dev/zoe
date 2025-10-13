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

[[vertex]] struct data_vertex zoe_shader_vertex(
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
  } else if (
    data_object->mode_texture == mode_texture_player
  ) {
    data_vertex.index_texture = 0;

    if (id_vertex == 0) {
      data_vertex.position_texture.x = 0.5f;
      data_vertex.position_texture.y = metal::fabs(1.0f - (float)(data_frame->frame % 221) / 110.0f);
    } else {
      data_vertex.position_texture.x = (float) ((id_vertex - 1)) / 6.0f;
      
      if (data_vertex.position_texture.x > 1.0f) {
        data_vertex.position_texture.x = 1.0f - (data_vertex.position_texture.x - 1.0f);
      }

      data_vertex.position_texture.y = metal::fabs(((float)(data_frame->frame % 667) / 333.0f) - 1.0f);
    }
  } else if (
    data_object->mode_texture == mode_texture_text
  ) {
    data_vertex.index_texture = 0;

    data_vertex.position_texture.x = (
      id_vertex == 0 || id_vertex == 3
      ? 0
      : 1
    );

    data_vertex.position_texture.y = (
      id_vertex == 0 || id_vertex == 1
      ? 1
      : 0
    );
  } else {
    data_vertex.index_texture = 0;
    data_vertex.height = positions[id_vertex].y / data_object->height;

    if (positions[id_vertex].x > data_object->width || positions[id_vertex].z > data_object->depth) {
      data_vertex.height = metal::fmin(positions[id_vertex].y / data_object->height * 0.2f, 0.2f);
      data_vertex.position_texture.y = id_vertex % 2 == 0 ? 1.0f : 0.0f;
      data_vertex.position_texture.x = (float)((unsigned short int)(metal::fabs(positions[id_vertex].x + positions[id_vertex].z) * 10000.0f) % 74) / 74.0f;
    } else {
      data_vertex.height = metal::fmin(positions[id_vertex].y / data_object->height * 0.8, 0.2f);
      data_vertex.position_texture.y = id_vertex % 20 < 10 ? 1.0f : 0.0f;
      data_vertex.position_texture.x = metal::fabs(positions[id_vertex].x + positions[id_vertex].z) / (data_object->width * 2.0f);
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

fragment float4 zoe_shader_fragment(
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

  if (
    data_vertex.mode_texture == mode_texture_text
  ) {
    return float4(
      texture_color[0] * data_vertex.noise * data_vertex.brightness_text,
      texture_color[1] * data_vertex.noise * data_vertex.brightness_text,
      texture_color[2] * data_vertex.noise * data_vertex.brightness_text,
      texture_color[3]
    );
  } else if (
    data_vertex.mode_texture == mode_texture_player
  ) {
    return float4(
      texture_color[0] * brightness * 0.02f,
      texture_color[1] * brightness * 0.019f,
      texture_color[2] * brightness * 0.02f,
      texture_color[3]
    );
  } else {
    if (
      data_vertex.mode_texture == mode_texture_ground
    ) {
      brightness = ((data_vertex.height * 0.8f) + 0.075f) * brightness;
    } else {
      brightness = ((data_vertex.height * 0.8f) + 0.075f) * (brightness * 0.8f);
    }

    brightness = brightness * metal::fmax(
      metal::fmin(
        100.0f / data_vertex.distance,
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
