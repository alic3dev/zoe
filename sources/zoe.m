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
  // srand(time_milliseconds_get() % UINT_MAX);
  
  // metil_paths_initialize(
  //   (char*) parameters[0]
  // );

  // unsigned char status_configuration_load = (
  //   metil_configuration_load()
  // );

  // if (
  //   status_configuration_load != 0
  // ) {
  //   paths_destroy();
  //   [[NSApplication sharedApplication] terminate: 0];
  //   return status_configuration_load;
  // }

  // termination_initialize();
  // interrupt_handler_initialize();
  // input_initialize();
  // scene_controller_initialize();
  // audio_initialize();
  // text_initialize();

  // configuration_values_set();

  // termination_on_function_add(
  //   scene_controller_destroy,
  //   (void*)0
  // );
  
  // termination_on_function_add(
  //   interrupt_handler_destroy,
  //   (void*)0
  // );

  // termination_on_function_add(
  //   paths_destroy,
  //   (void*)0
  // );

  // termination_on_function_add(
  //   audio_destroy,
  //   (void*)0
  // );

  // termination_on_function_add(
  //   text_destroy,
  //   (void*)0
  // );

  // termination_on_function_add(
  //   configuration_destroy,
  //   (void*)0
  // );

  // zoe_application* application = [zoe_application sharedApplication];
  // application.delegate = [zoe_application_delegate alloc];

  // interrupt_handler_interrupt_function_add(
  //   terminate_on_signal
  // );
  
  // return NSApplicationMain(
  //   length_parameters,
  //   parameters
  // );

  return metil_initialize(
    length_parameters,
    parameters,
    "zoe",
    zoe_renderer_on_initialize
  );
}

void zoe_renderer_on_initialize(
  id<MTLDevice> metil_metal_kit_device
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
