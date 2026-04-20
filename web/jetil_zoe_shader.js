var jetil_shader_default = (
`
struct data_vertex {
  @builtin(position) vertex: vec4<f32>,
  @location(0) colour: vec4<f32>,
  @location(1) vertex_raw: vec4<f32>,
  @location(3) index_vertex: f32,
  @location(4) index_instance: f32,
}

${jetil_shader_interpolative_defaults}

@vertex fn ${jetil_shader_default_name_vertex}(
  @location(${jetil_shader_index_vertex}) vertex: vec4<f32>,
  @location(${jetil_shader_index_data_object_colour}) data_object_colour: vec4<f32>,
  @location(${jetil_shader_index_data_object_position}) data_object_position: vec4<f32>,
  @location(${jetil_shader_index_data_object_rotation}) data_object_rotation: vec4<f32>,
  @builtin(vertex_index) index_vertex: u32,
  @builtin(instance_index) index_instance: u32
) -> data_vertex {
  var data_vertex_output: data_vertex;

  data_vertex_output.index_vertex = (
    f32(
      index_vertex
    )
  );

  data_vertex_output.index_instance = (
    f32(
      index_instance
    )
  );

  var matrix_projection: mat4x4<f32> = (
    jetil_matrix_projection_get(
      jetil_camera_matrix_projection,
      jetil_camera_matrix_projection_translation,
      jetil_player_position,
      jetil_player_rotation,
      data_object_position,
      data_object_rotation
    )
  );

  data_vertex_output.vertex = (
    matrix_projection *
    vertex
  );

  data_vertex_output.vertex_raw = (
    vertex
  );

  data_vertex_output.colour = (
    vec4<f32>(
      (
        data_object_colour[0] *
        jetil_data_frame[
          ${
            jetil_data_frame_buffer_index_time
          }
        ]
      ),
      (
        (
          data_object_colour[1] *
          0.75f
        ) +
        (
          data_object_colour[1] *
          0.25f *
          (
            jetil_data_frame[
              ${
                jetil_data_frame_buffer_index_time_delta
              }
            ] % 100
          ) /
          100.0f
        )
      ),
      data_object_colour[2],
      data_object_colour[3]
    )
  );

  return (
    data_vertex_output
  );
}

@fragment fn ${jetil_shader_default_name_fragment}(
  data_vertex_input: data_vertex
) -> @location(0) vec4<f32> {
  var distance: f32 = (
    (
      data_vertex_input.vertex_raw.z +
      0.625f
    ) /
    1.25f
  ) % 1.0f;

  if (
    distance < 0.0f
  ) {
    distance = (
      0.0f
    );
  }

  var brightness: f32 = (
    (
      distance *
      0.70f
    ) +
    0.30f
  );

  var colour = (
    vec4<f32>(
      (
        0.9f *
        data_vertex_input.colour.r *
        abs(
          data_vertex_input.vertex_raw.x /
          (
            0.5f +
            (
              (
                data_vertex_input.index_vertex *
                12.0f +
                jetil_data_frame[
                  ${jetil_data_frame_buffer_index_frame}
                ] +
                50
              ) %
              100
            ) /
            1000.0f
          )
        ) +
        0.1
      ),
      (
        0.9f *
        data_vertex_input.colour.g *
        abs(
          data_vertex_input.vertex_raw.z /
          (
            0.5f +
            (
              (
                data_vertex_input.index_vertex *
                14.123f +
                jetil_data_frame[
                  ${jetil_data_frame_buffer_index_frame}
                ] +
                86
              ) %
              100
            ) /
            1000.0f
          )
        ) +
        0.1
      ),
      (
        (
          data_vertex_input.colour.b *
          abs(
            data_vertex_input.vertex_raw.y /
            (
              0.5f +
              (
                data_vertex_input.index_instance *
                5.234f
              ) /
              500.0f
            )
          )
        ) *
        0.9f +
        0.1f
      ),
      data_vertex_input.colour.a
    )
  );

  if (
    colour.r > 1.0f
  ) {
    colour.r = (
      colour.r -
      floor(
        colour.r
      )
    );
  }

  if (
    colour.g > 1.0f
  ) {
    colour.g = (
      colour.g -
      floor(
        colour.g
      )
    );
  }

  if (
    colour.b > 1.0f
  ) {
    colour.b = (
      colour.b -
      floor(
        colour.b
      )
    );
  }

  return (
    vec4<f32>(
      (
        colour.r *
        brightness *
        jetil_data_frame[
          ${jetil_data_frame_buffer_index_brightness}
        ]
      ),
      (
        colour.g *
        brightness *
        jetil_data_frame[
          ${jetil_data_frame_buffer_index_brightness}
        ]
      ),
      (
        colour.b *
        brightness *
        jetil_data_frame[
          ${jetil_data_frame_buffer_index_brightness}
        ]
      ),
      colour.a
    )
  );
}
`
);
