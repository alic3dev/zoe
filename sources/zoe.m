#include <zoe.h>

#include <scenes/scene_id.h>
#include <scenes/scene_intro_forest.h>
#include <scenes/scene_intro_hill.h>
#include <scenes/scene_menu_main.h>
#include <zoe_pipeline_index.h>

#include <metil_application/metil_application.h>
#include <metil_application/metil_application_delegate.h>
#include <metil_application/metil_view_controller.h>
#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_object/metil_object_text.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/metil_scene_controller.h>

#if target_os_ios
char* zoe_executable_path = (
  (void*) 0
);
#endif

int main(
  int length_parameters,
  #if target_os_ios
  char** parameters
  #else
  const char** parameters
  #endif
) {
  #if target_os_ios
  zoe_executable_path = (
    parameters[0]
  );

  metil_view_controller_on_view_did_load = (
    zoe_view_controller_on_view_did_load
  );

  return UIApplicationMain(
    length_parameters,
    parameters,
    NSStringFromClass([metil_application class]),
    NSStringFromClass([metil_application_delegate class])
  );
  #else
  return metil_initialize(
    length_parameters,
    parameters,
    "zoe",
    zoe_renderer_on_initialize
  );
  #endif
}

#if target_os_ios
void zoe_view_controller_on_view_did_load() {
  metil_initialize(
    1,
    &zoe_executable_path,
    "zoe",
    zoe_renderer_on_initialize
  );
}
#endif

void zoe_renderer_on_initialize(
  struct metil* metil,
  void* data
) {
  metil->player_defaults.speed_movement = 64.0f;

  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"zoe_default_fragment",
    @"zoe_default_vertex"
  );

  zoe_pipeline_index_ground = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_ground_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_ground_vertex"
    ]
  ];

  zoe_pipeline_index_hill = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_hill_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_hill_vertex"
    ]
  ];

  zoe_pipeline_index_player = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_player_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_player_vertex"
    ]
  ];

  zoe_pipeline_index_text = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_text_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_text_vertex"
    ]
  ];

  zoe_pipeline_index_tree = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_tree_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_tree_vertex"
    ]
  ];

  metil->text_defaults.object_text_index_pipeline_render = (
    zoe_pipeline_index_text
  );

  metil->rendering_properties.color_clear.x = 0.0324f;
  metil->rendering_properties.color_clear.y = 0.0424f;
  metil->rendering_properties.color_clear.z = 0.0649f;
  metil->rendering_properties.color_clear.w = 1.0f;

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  scene_menu_main_initialize(
    metil,
    &metil_scene_controller->scene
  );

  metil_scene_controller_on_scene_change_add(
    metil_scene_controller,
    zoe_on_scene_change,
    (void*) 0
  );
}

void zoe_on_scene_change(
  struct metil* metil,
  int id_scene,
  void* data
) {
  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene = &(
    metil_scene_controller->scene
  );

  metil_scene_destroy(
    metil,
    metil_scene
  );

  switch (
    id_scene
  ) {
    case scene_id_intro_forest:
      scene_intro_forest_initialize(
        metil,
        metil_scene
      );
      break;
    case scene_id_intro_hill:
      scene_intro_hill_initialize(
        metil,
        metil_scene
      );
      break;
    case scene_id_menu_main:
    case scene_id_unknown:
    default:
      scene_menu_main_initialize(
        metil,
        metil_scene
      );
      break;
  }
}
