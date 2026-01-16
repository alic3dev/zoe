#include <scenes/scene_intro_forest/scene_intro_forest_loading.h>

#include <scenes/scene_intro_forest/scene_intro_forest.h>
#include <zoe_loading_threads.h>

#include <clic3_memory.h>

unsigned char zoe_scene_intro_forest_loading_initialize_function(
  struct metil* metil,
  struct metil_scene* metil_scene,
  unsigned char id_scene,
  void** data
) {
  *data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_loading_threads
      )
    )
  );

  struct zoe_loading_threads* zoe_loading_threads = (
    *data
  );

  zoe_loading_threads_initialize(
    zoe_loading_threads,
    metil,
    metil_scene,
    id_scene
  );

  zoe_loading_threads_spawn(
    zoe_loading_threads,
    zoe_scene_intro_forest_loading_initialize_threaded_function,
    0
  );

  return 0;
}

void zoe_scene_intro_forest_loading_initialize_threaded_function(
  struct zoe_loading_threads_data* zoe_loading_threads_data
) {
  scene_intro_forest_initialize(
    zoe_loading_threads_data->metil,
    zoe_loading_threads_data->scene,
    zoe_loading_threads_data->progress
  );

  *zoe_loading_threads_data->progress = 1.0f;
}

float zoe_scene_intro_forest_loading_poll_function(
  struct metil* metil,
  struct metil_scene* metil_scene,
  unsigned char id_scene,
  void** data
) {
  struct zoe_loading_threads* zoe_loading_threads = (
    *data
  );

  return (
    zoe_loading_threads->progress
  );
}

void zoe_scene_intro_forest_loading_finished_function(
  struct metil* metil,
  struct metil_scene* metil_scene,
  unsigned char id_scene,
  void** data
) {
  struct zoe_loading_threads* zoe_loading_threads = (
    *data
  );

  zoe_loading_threads_destroy(
    zoe_loading_threads
  );
}
