#include <zoe_loading_map.h>

#include <scenes/scene_id.h>
#include <scenes/scene_intro_forest/scene_intro_forest_loading.h>
#include <scenes/scene_intro_hill.h>
#include <scenes/scene_menu_main.h>

void zoe_loading_map_initialize(
  struct zoe_loading_map* zoe_loading_map,
  unsigned char id_scene
) {
  zoe_loading_map->initialize = (
    zoe_loading_map_initialize_function_get(
      id_scene
    )
  );

  zoe_loading_map->poll = (
    zoe_loading_map_poll_function_get(
      id_scene
    )
  );

  zoe_loading_map->finished = (
    zoe_loading_map_finished_function_get(
      id_scene
    )
  );
}

zoe_scene_loading_loading_initialize_function zoe_loading_map_initialize_function_get(
  unsigned char id_scene
) {
  switch (
    id_scene
  ) {
    case scene_id_intro_forest:
      return (
        zoe_scene_intro_forest_loading_initialize_function
      );
    case scene_id_intro_hill:
    case scene_id_menu_main:
    case scene_id_unknown:
    default: {
      return (
        zoe_scene_loading_loading_initialize_function_no_load
      );
    }
  }
}

zoe_scene_loading_loading_poll_function zoe_loading_map_poll_function_get(
  unsigned char id_scene
) {
  switch (
    id_scene
  ) {
    case scene_id_intro_forest:
      return (
        zoe_scene_intro_forest_loading_poll_function
      );
    case scene_id_intro_hill:
    case scene_id_menu_main:
    case scene_id_unknown:
    default: {
      return (
        zoe_scene_loading_loading_poll_function_no_load
      );
    }
  }
}

zoe_scene_loading_loading_finished_function zoe_loading_map_finished_function_get(
  unsigned char id_scene
) {
  switch (
    id_scene
  ) {
    case scene_id_intro_forest:
      return (
        zoe_scene_intro_forest_loading_finished_function
      );
    case scene_id_intro_hill:
    case scene_id_menu_main:
    case scene_id_unknown:
    default: {
      return (
        zoe_scene_loading_loading_finished_function_no_load
      );
    }
  }
}

unsigned char zoe_scene_loading_loading_initialize_function_no_load(
  struct metil* metil,
  struct metil_scene* metil_scene,
  unsigned char id_scene,
  void** data
) {
  switch (
    id_scene
  ) {
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

  return (
    0x01
  );
}

float zoe_scene_loading_loading_poll_function_no_load(
  struct metil* metil,
  struct metil_scene* metil_scene,
  unsigned char id_scene,
  void** data
) {
  return (
    0x01
  );
}

void zoe_scene_loading_loading_finished_function_no_load(
  struct metil* metil,
  struct metil_scene* metil_scene,
  unsigned char id_scene,
  void** data
) {
}
