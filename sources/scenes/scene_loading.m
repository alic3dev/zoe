#include <scenes/scene_loading.h>

#include <zoe_loading_map.h>

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

void scene_loading_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene_loading,
  unsigned char id_scene
) {
  static struct data_scene_loading* data_scene_loading;
  
  data_scene_loading = (
    clic3_memory_allocate_raw(
      sizeof(
        struct data_scene_loading
      )
    )
  );

  data_scene_loading->data = 0;

  data_scene_loading->id_scene = (
    id_scene
  );
  
  zoe_loading_map_initialize(
    &data_scene_loading->loading_map,
    data_scene_loading->id_scene
  );

  unsigned char initialized = (
    data_scene_loading->loading_map.initialize(
      metil,
      &data_scene_loading->scene,
      data_scene_loading->id_scene,
      &data_scene_loading->data
    )
  );

  if (
    initialized != 0
  ) {
    scene_loading_finished(
      metil,
      metil_scene_loading,
      data_scene_loading
    );

    return;
  }
  
  metil_scene_initialize_with_renderables(
    metil,
    metil_scene_loading,
    0
  );

  metil_scene_loading->data = (
    data_scene_loading
  );

  metil_scene_loading->poll = (
    scene_loading_poll
  );
}

void scene_loading_poll(
  struct metil* metil,
  struct metil_scene* metil_scene_loading
) {
  struct data_scene_loading* data_scene_loading = (
    metil_scene_loading->data
  );

  unsigned char initialized = (
    data_scene_loading->loading_map.poll(
      metil,
      &data_scene_loading->scene,
      data_scene_loading->id_scene,
      &data_scene_loading->data
    )
  );

  if (
    initialized != 0
  ) {
    struct data_scene_loading* data_scene_loading = (
      metil_scene_loading->data
    );

    metil_scene_loading->data = 0;

    metil_scene_loading->destroy(
      metil,
      metil_scene_loading
    );

    metil_scene_loading->data = (
      data_scene_loading
    );

    scene_loading_finished(
      metil,
      metil_scene_loading,
      data_scene_loading
    );

    return;
  }
}

void scene_loading_finished(
  struct metil* metil,
  struct metil_scene* metil_scene_loading,
  struct data_scene_loading* data_scene_loading
) {
  clic3_bytes_copy(
    metil_scene_loading,
    &data_scene_loading->scene,
    sizeof(
      struct metil_scene
    )
  );

  data_scene_loading->loading_map.finished(
    metil,
    metil_scene_loading,
    data_scene_loading->id_scene,
    &data_scene_loading->data
  );

  clic3_memory_free(
    data_scene_loading->data
  );

  clic3_memory_free_raw(
    data_scene_loading
  );
}
