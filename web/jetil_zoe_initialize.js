function jetil_zoe_initialize(
  id_jetil_zoe_canvas
) {
  window.setTimeout(
    function jetil_zoe_initialize_deferred() {
      var element_canvas = (
        document.getElementById(
          id_jetil_zoe_canvas
        )
      );

      jetil_initialize(
        element_canvas,
        example_on_initialized
      );
    },
    0x00
  );
}

function example_on_initialized(
  jetil_structure
) {
  if (
    jetil_structure ==
    0x00
  ) {
    console.error(
      "failed_to_initialize::jetil"
    );

    return;
  }

  jetil_zoe_shader_compiled_index_zoe = (
    jetil_shader_compile(
      jetil_structure,
      jetil_zoe_shader
    )
  );

  if (
    jetil_zoe_shader_compiled_index_zoe ==
    -0x01
  ) {
    console.error(
      "failed_to_compile->{jetil_zoe_shader};"
    );
  } else {
    jetil_renderer_bind_initialize(
      jetil_structure,
      jetil_structure.rendering_properties.bind,
      0x00,
      0x00,
      0x00
    );

    var jetil_descriptor_pipeline_render_zoe = (
      jetil_descriptor_pipeline_render_initialize(
        jetil_structure,
        jetil_structure.buffers.vertex[
          0x00
        ],
        jetil_structure.shaders[
          jetil_zoe_shader_compiled_index_zoe
        ],
        jetil_structure.shaders[
          jetil_zoe_shader_compiled_index_zoe
        ],
        jetil_zoe_shader_name_vertex,
        jetil_zoe_shader_name_fragment,
        jetil_primitive_type_default,
        0x00
      )
    );

    jetil_structure.descriptors.pipeline_render.push(
      jetil_descriptor_pipeline_render_zoe
    );

    jetil_zoe_pipeline_index_zoe = (
      jetil_structure.descriptors.pipeline_render.length -
      0x01
    );

    jetil_render_pipeline_initialize(
      jetil_structure,
      jetil_structure.descriptors.pipeline_render[
        jetil_zoe_pipeline_index_zoe
      ]
    );
  }

  var jetil_scene = (
    jetil_structure.scene_controller.scene
  );

  jetil_zoe_scene_initialize(
    jetil_structure,
    jetil_scene
  );
}
