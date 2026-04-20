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

  var jetil_scene = (
    jetil_structure.scene_controller.scene
  );

  jetil_zoe_scene_initialize(
    jetil_structure,
    jetil_scene
  );
}
