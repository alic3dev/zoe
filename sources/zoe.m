#include <zoe.h>

#include <data/data_zoe.h>
#include <scenes/scene_id.h>
#include <scenes/scene_loading.h>
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

#include <clic3_memory.h>

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

  zoe_pipeline_index_loading_screen = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_loading_screen_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_loading_screen_vertex"
    ]
  ];

  zoe_pipeline_index_player_arm = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_player_arm_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_player_arm_vertex"
    ]
  ];

  zoe_pipeline_index_player_body = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_player_body_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_player_body_vertex"
    ]
  ];

  zoe_pipeline_index_player_head = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_player_head_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_player_head_vertex"
    ]
  ];

  zoe_pipeline_index_player_leg = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_player_leg_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_player_leg_vertex"
    ]
  ];

  zoe_pipeline_index_leaf = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_leaf_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_leaf_vertex"
    ]
  ];

  zoe_pipeline_index_mushroom = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_mushroom_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_mushroom_vertex"
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

  zoe_pipeline_index_text_backing = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_text_backing_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_text_backing_vertex"
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

  zoe_pipeline_index_zoe_body = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_zoe_body_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_zoe_body_vertex"
    ]
  ];

  metil->text_defaults.object_text_index_pipeline_render = (
    zoe_pipeline_index_text
  );

  metil->rendering_properties.colour_clear.x = 0.0324f;
  metil->rendering_properties.colour_clear.y = 0.0424f;
  metil->rendering_properties.colour_clear.z = 0.0649f;
  metil->rendering_properties.colour_clear.w = 1.0f;

  metil->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_data_zoe
      )
    )
  );

  zoe_data_zoe_initialize(
    metil->data
  );

  metil->destroy = (
    zoe_destroy
  );

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
    0x00
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

  scene_loading_initialize(
    metil,
    metil_scene,
    id_scene
  );
}

void zoe_destroy(
  struct metil* metil
) {
  clic3_memory_free_raw(
    metil->data
  );
}
