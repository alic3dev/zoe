#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float distance;
  float height;
  float2 position_texture;
  unsigned char index_texture;
  float noise;
  float brightness;
  float brightness_text;
};

[[vertex]] struct data_vertex zoe_tree_vertex(
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
  data_vertex.noise = (float)(data_object->noise % 10001) / 10000.0f;

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

fragment float4 zoe_tree_fragment(
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

  float brightness = (
    ((data_vertex.height * 0.8f) + 0.075f) *
    (data_vertex.brightness * 0.8f)
  ) * metal::fmax(
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
