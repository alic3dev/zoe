function jetil_zoe_scene_initialize(
  jetil_structure,
  jetil_scene
) {
  jetil_scene_initialize(
    jetil_structure,
    jetil_scene
  );

  jetil_scene.length_renderables = (
    0x02
  );

  for (
    var index_renderable = 0;
    index_renderable < jetil_scene.length_renderables;
    ++index_renderable
  ) {
    jetil_scene.renderables.push(
      {}
    );

    var jetil_renderable = (
      jetil_scene.renderables[
        index_renderable
      ]
    );

    jetil_renderable_initialize(
      jetil_structure,
      jetil_renderable,
      jetil_renderable_type_object
    );

    var jetil_object = (
      jetil_renderable.renderable
    );

    var jetil_mesh = (
      jetil_object.mesh
    );

    jetil_mesh_sphere_initialize(
      jetil_structure,
      jetil_mesh,
      0x0a,
      {
        x: (
          0x64
        ),
        y: (
          0x64
        )
      }
    );

    var percentage = (
      index_renderable /
      (
        jetil_scene.length_renderables -
        1
      )
    );

    jetil_object.position[
      jetil_vector_index_x
    ] = (
      percentage *
      2.0
    );

    jetil_object.position[
      jetil_vector_index_y
    ] = (
      10.0
    );

    jetil_object.rotation[
      jetil_vector_index_x
    ] = (
      index_renderable *
      Math.PI
    );

    jetil_object.rotation[
      jetil_vector_index_y
    ] = (
      index_renderable *
      Math.PI /
      2.0
    );

    jetil_object_buffers_initialize(
      jetil_structure,
      jetil_object
    );

    var jetil_object_buffer_data_object = (
      jetil_object.data_object
    );

    jetil_object_buffer_data_object[0] = (
      0.5
    );

    jetil_object_buffer_data_object[1] = (
      0.2
    );

    jetil_object_buffer_data_object[2] = (
      1.0
    );

    jetil_object.poll = (
      example_jetil_scene_object_poll
    );
  }

  jetil_scene.player.position[
    jetil_vector_index_z
  ] = (
    -0x64
  );
}

function example_jetil_scene_object_poll(
  jetil_structure,
  jetil_object
) {
  jetil_object.rotation[
    jetil_vector_index_x
  ] = (
    jetil_object.rotation[
      jetil_vector_index_x
    ] +
    (
      0.0001234 *
      jetil_structure.scene_controller.scene.time_delta
    )
  );

  jetil_object.rotation[
    jetil_vector_index_y
  ] = (
    jetil_object.rotation[
      jetil_vector_index_y
    ] +
    (
      0.0001234 *
      jetil_structure.scene_controller.scene.time_delta
    )
  );

  jetil_object_poll_default(
    jetil_structure,
    jetil_object
  );
}
