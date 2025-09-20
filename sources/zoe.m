#include <zoe.h>

#include <scenes/scene_id.h>
#include <scenes/scene_intro_forest.h>
#include <scenes/scene_menu_main.h>

#include <metil.h>

#include <AppKit/AppKit.h>

id<MTLDevice> metal_kit_device = (void*)0;

int main(
  int length_parameters,
  const char** parameters
) {
  return metil_initialize(
    length_parameters,
    parameters,
    "zoe",
    zoe_renderer_on_initialize
  );
}

void zoe_renderer_on_initialize(
  id<MTLDevice> metil_metal_kit_device,
  struct metil_rendering_properties* metil_rendering_properties
) {
  metal_kit_device = metil_metal_kit_device;

  metil_library.library = [metal_kit_device newDefaultLibrary];

  metil_library.function_vertex = [
    metil_library.library
    newFunctionWithName: @"zoe_shader_vertex"
  ];

  metil_library.function_fragment = [
    metil_library.library
    newFunctionWithName: @"zoe_shader_fragment"
  ];

  metil_rendering_properties->color_clear.x = 0.0324f;
  metil_rendering_properties->color_clear.y = 0.0424f;
  metil_rendering_properties->color_clear.z = 0.0649f;
  metil_rendering_properties->color_clear.w = 1.0f;

  scene_menu_main_initialize(
    &metil_scene_controller.scene,
    metal_kit_device
  );

  metil_scene_controller_on_scene_change_add(
    zoe_on_scene_change,
    (void*)0
  );
}

void zoe_on_scene_change(
  int id_scene,
  void* _
) {
  metil_scene_destroy(
    &metil_scene_controller.scene
  );

  switch (
    id_scene
  ) {
    case scene_id_unknown:
    case scene_id_menu_main:
      scene_menu_main_initialize(
        &metil_scene_controller.scene,
        metal_kit_device
      );
      break;
    case scene_id_intro_forest:
      scene_intro_forest_initialize(
        &metil_scene_controller.scene,
        metal_kit_device
      );
      break;
  }
}
