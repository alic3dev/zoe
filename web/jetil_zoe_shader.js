var jetil_zoe_shader_name_vertex = (
  "jetil_zoe_shader_vertex"
);

var jetil_zoe_shader_name_fragment = (
  "jetil_zoe_shader_fragment"
);

var jetil_zoe_shader = (
`
struct data_vertex {
  @builtin(position) vertex: vec4<f32>,
  @location(0) colour: vec4<f32>,
  @location(1) vertex_raw: vec4<f32>,
  @location(3) index_vertex: f32,
  @location(4) index_instance: f32,
}

${jetil_shader_interpolative_defaults}

@vertex fn ${jetil_zoe_shader_name_vertex}(
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
      data_object_colour[
        0x00
      ],
      data_object_colour[
        0x01
      ],
      data_object_colour[
        0x02
      ],
      data_object_colour[
        0x03
      ]
    )
  );

  return (
    data_vertex_output
  );
}

@fragment fn ${jetil_zoe_shader_name_fragment}(
  data_vertex_input: data_vertex
) -> @location(0) vec4<f32> {
  var brightness: f32 = (
    (
      data_vertex_input.index_vertex +
      data_vertex_input.index_instance
    ) /
    100.0f
  );

  if (
    brightness >
    0x01
  ) {
    brightness = (
      brightness -
      f32(
        i32(
          brightness
        )
      )
    );
  }

  brightness = (
    brightness *
    jetil_data_frame[
      ${jetil_data_frame_buffer_index_brightness}
    ]
  );

  return (
    vec4<f32>(
      (
        data_vertex_input.colour.x *
        brightness
      ),
      (
        data_vertex_input.colour.y *
        brightness
      ),
      (
        data_vertex_input.colour.z *
        brightness
      ),
      data_vertex_input.colour.a
    )
  );
}
`
);
