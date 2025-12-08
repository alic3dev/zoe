#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float distance;
  float2 position_texture;
  unsigned char index_texture;
  float brightness;
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

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    positions[
      id_vertex
    ]
  );

  data_vertex.index_texture = 0;

  if (
    positions[id_vertex].x > data_object->size.x ||
    positions[id_vertex].x < -data_object->size.x ||
    positions[id_vertex].z > data_object->size.z ||
    positions[id_vertex].z < -data_object->size.z
  ) {
    data_vertex.position_texture.y = id_vertex % 2 == 0 ? 1.0f : 0.0f;
    data_vertex.position_texture.x = (
      (float) (
        (unsigned short int) (
          metal::fabs(
            positions[id_vertex].x +
            positions[id_vertex].z
          ) * 10000.0f
        ) % 74
      ) / 74.0f
    );
  } else {
    data_vertex.position_texture.y = id_vertex % 20 < 10 ? 1.0f : 0.0f;
    data_vertex.position_texture.x = metal::fabs(positions[id_vertex].x + positions[id_vertex].z) / (data_object->size.x * 2.0f);
  }

  data_vertex.brightness = data_frame->brightness;

  data_vertex.distance = metal::distance(
    metal::float3(
      metal::float3(
        data_object->position.x,
        data_object->position.y,
        data_object->position.z
      ) +
      metal::float3(
        positions[id_vertex].x,
        positions[id_vertex].y,
        -positions[id_vertex].z
      )
    ),
    metal::float3(
      data_frame->position_player.x,
      data_frame->position_player.y,
      data_frame->position_player.z
    )
  );

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

  float brightness = metal::fmin(
    metal::fmax(
      1.0f - data_vertex.distance / 1000.0f,
      0.0f
    ),
    1.0f
  );

  return float4(
    brightness,
    brightness,
    brightness,
    1.0f
  );
}
