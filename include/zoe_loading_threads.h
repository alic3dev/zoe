#ifndef __zoe_loading_threads_h
#define __zoe_loading_threads_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#include <pthread.h>

struct zoe_loading_threads_data {
  struct metil* metil;
  struct metil_scene* scene;
  unsigned char id_scene;
  float* progress;
  void* data;
};

typedef void (*zoe_loading_threads_function)(
  struct zoe_loading_threads_data*
);

struct zoe_loading_threads_passthrough_data {
  struct zoe_loading_threads_data* data;
  zoe_loading_threads_function function;
};

struct zoe_loading_threads {
  pthread_t* threads;
  struct zoe_loading_threads_data* data;
  unsigned char length;

  struct metil* metil;
  struct metil_scene* scene;
  unsigned char id_scene;

  float progress;
};

void zoe_loading_threads_initialize(
  struct zoe_loading_threads*,
  struct metil*,
  struct metil_scene*,
  unsigned char
);

void zoe_loading_threads_spawn(
  struct zoe_loading_threads*,
  zoe_loading_threads_function,
  void*
);

void* zoe_loading_threads_passthrough (
  void*
);

void zoe_loading_threads_destroy(
  struct zoe_loading_threads*
);

#endif
