#include <zoe_scenes/scene_intro_forest/scene_intro_forest_loading.h>

#include <zoe_data/zoe_data_scene_intro_forest.h>
#include <zoe_loading_threads.h>
#include <zoe_scenes/scene_intro_forest/scene_intro_forest.h>

#include <clic3_memory.h>

#include <pthread.h>

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
    scene_intro_forest_initialize,
    0x00
  );

  return (
    0x00
  );
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

  pthread_mutex_lock(
    &zoe_loading_threads->mutex_progress
  );

  float progress = (
    zoe_loading_threads->progress
  );

  pthread_mutex_unlock(
    &zoe_loading_threads->mutex_progress
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

  struct zoe_data_scene_intro_forest* zoe_data_scene_intro_forest = (
    metil_scene->data
  );
  
  zoe_data_scene_intro_forest->attack_effects_controller.time = &(
    metil_scene->time_elapsed
  );
}
