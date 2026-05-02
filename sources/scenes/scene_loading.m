#include <scenes/scene_loading.h>

#include <data/data_zoe.h>
#include <zoe_loading_map.h>
#include <zoe_pipeline_index.h>

#include <metil.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_square.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <math_c_absolute.h>

void scene_loading_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene_loading,
  unsigned char id_scene
) {
  struct zoe_data_zoe* zoe_data_zoe = (
    metil->data
  );

  struct zoe_pipeline_index* zoe_pipeline_index = &(
    zoe_data_zoe->pipeline_index
  );

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
    1
  );

  metil_renderable_initialize_at_index(
    metil_scene_loading->renderables,
    0,
    metil_renderable_type_object
  );

  struct metil_object* metil_object_loading_screen = (
    metil_scene_loading->renderables[
      0
    ].renderable
  );

  metil_mesh_square_initialize(
    &metil_object_loading_screen->mesh,
    2.0f
  );

  metil_object_loading_screen->positioning = (
    metil_positioning_absolute
  );

  metil_object_loading_screen->index_pipeline_render = (
    zoe_pipeline_index->loading_screen
  );

  metil_object_buffers_initialize(
    metil_object_loading_screen,
    metil->renderer_interface.metal_device
  );

  struct metil_renderer_data_object* metil_renderer_data_object_loading_screen = (
    metil_object_loading_screen->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  metil_renderer_data_object_loading_screen->noise = (
    0x00
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

  float progress = (
    data_scene_loading->loading_map.poll(
      metil,
      &data_scene_loading->scene,
      data_scene_loading->id_scene,
      &data_scene_loading->data
    )
  );

  struct metil_object* metil_object_loading_screen = (
    metil_scene_loading->renderables[
      0
    ].renderable
  );

  struct metil_renderer_data_object* metil_renderer_data_object_loading_screen = (
    metil_object_loading_screen->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  metil_renderer_data_object_loading_screen->noise = (
    math_c_absolute_float(
      progress
    ) *
    10000.0f
  );

  if (
    progress >=
    0x01
  ) {
    struct data_scene_loading* data_scene_loading = (
      metil_scene_loading->data
    );

    metil_scene_loading->data = (
      0x00
    );

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
