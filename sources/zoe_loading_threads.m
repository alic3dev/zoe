#include <zoe_loading_threads.h>

#include <clic3_memory.h>

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#include <pthread.h>

void zoe_loading_threads_initialize(
  struct zoe_loading_threads* zoe_loading_threads,
  struct metil* metil,
  struct metil_scene* metil_scene,
  unsigned char id_scene
) {
  zoe_loading_threads->threads = (
    clic3_memory_allocate_raw(
      sizeof(
        pthread_t
      )
    )
  );

  zoe_loading_threads->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_loading_threads_data
      )
    )
  );

  zoe_loading_threads->metil = (
    metil
  );

  zoe_loading_threads->scene = (
    metil_scene
  );

  zoe_loading_threads->id_scene = (
    id_scene
  );

  zoe_loading_threads->length = 0;

  zoe_loading_threads->progress = 0.0f;
  
  pthread_mutex_init(
    &zoe_loading_threads->mutex_progress,
    0
  );
}

void zoe_loading_threads_spawn(
  struct zoe_loading_threads* zoe_loading_threads,
  zoe_loading_threads_function zoe_loading_threads_function,
  void* data
) {
  zoe_loading_threads->length = (
    zoe_loading_threads->length +
    1
  );

  clic3_memory_reallocate_raw(
    &zoe_loading_threads->threads,
    (
      sizeof(
        pthread_t
      ) *
      zoe_loading_threads->length
    )
  );

  clic3_memory_reallocate_raw(
    &zoe_loading_threads->data,
    (
      sizeof(
        struct zoe_loading_threads_data
      ) *
      zoe_loading_threads->length
    )
  );

  struct zoe_loading_threads_data* zoe_loading_threads_data = &(
    zoe_loading_threads->data[
      zoe_loading_threads->length -
      1
    ]
  );

  zoe_loading_threads_data->metil = (
    zoe_loading_threads->metil
  );

  zoe_loading_threads_data->scene = (
    zoe_loading_threads->scene
  );

  zoe_loading_threads_data->id_scene = (
    zoe_loading_threads->id_scene
  );

  zoe_loading_threads_data->data = (
    data
  );

  zoe_loading_threads_data->progress = (
    &zoe_loading_threads->progress
  );

  static struct zoe_loading_threads_passthrough_data* zoe_loading_threads_passthrough_data;

  zoe_loading_threads_passthrough_data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_loading_threads_passthrough_data
      )
    )
  );

  zoe_loading_threads_passthrough_data->data = (
    zoe_loading_threads_data
  );

  zoe_loading_threads_passthrough_data->function = (
    zoe_loading_threads_function
  );

  pthread_create(
    &zoe_loading_threads->threads[
      zoe_loading_threads->length -
      1
    ],
    0,
    zoe_loading_threads_passthrough,
    zoe_loading_threads_passthrough_data
  );
}

void* zoe_loading_threads_passthrough (
  void* data
) {
  struct zoe_loading_threads_passthrough_data* zoe_loading_threads_passthrough_data = (
    data
  );

  zoe_loading_threads_passthrough_data->function(
    zoe_loading_threads_passthrough_data->data
  );

  clic3_memory_free_raw(
    zoe_loading_threads_passthrough_data
  );

  return 0;
}

void zoe_loading_threads_destroy(
  struct zoe_loading_threads* zoe_loading_threads
) {
  for (
    unsigned char index_thread = 0;
    index_thread < zoe_loading_threads->length;
    ++index_thread
  ) {
    pthread_join(
      zoe_loading_threads->threads[
        index_thread
      ],
      0
    );

    struct zoe_loading_threads_data* zoe_loading_threads_data = &(
      zoe_loading_threads->data[
        index_thread
      ]
    );

    clic3_memory_free(
      zoe_loading_threads_data->data
    );
  }

  pthread_mutex_destroy(
    &zoe_loading_threads->mutex_progress
  );

  clic3_memory_free_raw(
    zoe_loading_threads->data
  );

  clic3_memory_free_raw(
    zoe_loading_threads->threads
  );
}
