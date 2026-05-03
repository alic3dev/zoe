#include <zoe.h>

#include <zoe_data/data_zoe.h>
#include <zoe_pipeline_index.h>
#include <zoe_scenes/scene_id.h>
#include <zoe_scenes/scene_loading.h>
#include <zoe_scenes/scene_menu_main.h>

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
  0x000
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
    parameters[
      0x00
    ]
  );

  metil_view_controller_on_view_did_load = (
    zoe_view_controller_on_view_did_load
  );

  return UIApplicationMain(
    length_parameters,
    parameters,
    NSStringFromClass(
      [
        metil_application
        class
      ]
    ),
    NSStringFromClass(
      [
        metil_application_delegate
        class
      ]
    )
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
    0x01,
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
  metil->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_data_zoe
      )
    )
  );

  struct zoe_data_zoe* zoe_data_zoe = (
    metil->data
  );

  zoe_data_zoe_initialize(
    metil,
    zoe_data_zoe
  );

  struct zoe_pipeline_index* zoe_pipeline_index = &(
    zoe_data_zoe->pipeline_index
  );

  metil->player_defaults.speed_movement = (
    0x40
  );

  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"zoe_default_fragment",
    @"zoe_default_vertex"
  );

  zoe_pipeline_index->auop = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_auop_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_auop_vertex"
    ]
  ];

  zoe_pipeline_index->ground = [
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

  zoe_pipeline_index->hill = [
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

  zoe_pipeline_index->loading_screen = [
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

  zoe_pipeline_index->leaf = [
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

  zoe_pipeline_index->mushroom = [
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

  zoe_pipeline_index->text = [
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

  zoe_pipeline_index->text_backing = [
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

  zoe_pipeline_index->tree = [
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

  zoe_pipeline_index->zoe_body = [
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

  zoe_pipeline_index->zoe_hair = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"zoe_zoe_hair_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"zoe_zoe_hair_vertex"
    ]
  ];

  metil->text_defaults.object_text_index_pipeline_render = (
    zoe_pipeline_index->text
  );

  metil->rendering_properties.colour_clear.x = (
    0.0324f
  );

  metil->rendering_properties.colour_clear.y = (
    0.0424f
  );

  metil->rendering_properties.colour_clear.z = (
    0.0649f
  );

  metil->rendering_properties.colour_clear.w = (
    0x01
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
  struct zoe_data_zoe* zoe_data_zoe = (
    metil->data
  );

  zoe_data_zoe_destroy(
    metil,
    zoe_data_zoe
  );
  clic3_memory_free_raw(
    metil->data
  );
}
