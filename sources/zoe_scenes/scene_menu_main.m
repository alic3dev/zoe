#include <zoe_scenes/scene_menu_main.h>

#include <zoe_audio/zoe_audio_io_proc_scene_menu_main.h>
#include <zoe_data/data_zoe.h>
#include <zoe_data/zoe_data_scene_menu_main.h>
#include <zoe_menus/menu_main.h>
#include <zoe_object/object_ground.h>
#include <zoe_object/object_tree.h>
#include <zoe_pipeline_index.h>
#include <zoe_save_files/zoe_save_file.h>
#include <zoe_scenes/scene_id.h>
#include <zoe_textures/zoe_texture_static.h>

#include <math_c_minimum.h>
#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metil.h>
#include <metil_audio/metil_audio_io_proc.h>
#include <metil_audio/metil_audio_io_proc_data.h>
#include <metil_debug/metil_debug_log.h>
#include <metil_menus/metil_menu.h>
#include <metil_menus/metil_menu_input.h>
#include <metil_object/metil_object_text.h>
#include <metil_paths/metil_paths.h>
#include <metil_rendering/metil_camera/metil_camera.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>
#if target_os_ios
#include <metil_termination/metil_termination.h>
#endif

#include <clic3_memory.h>

#include <rand_clean.h>
#include <rand_functions.h>
#include <rand_initialize.h>
#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>
#include <rand_source_type.h>

void scene_menu_main_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct zoe_data_zoe* zoe_data_zoe = (
    metil->data
  );

  struct zoe_pipeline_index* zoe_pipeline_index = &(
    zoe_data_zoe->pipeline_index
  );

  metil_scene_initialize_with_renderables(
    metil,
    scene,
    0x05
  );

  scene->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct scene_menu_main_data
      )
    )
  );

  struct scene_menu_main_data* data_scene = (
    scene->data
  );

  struct io_proc_data* io_proc_data = (
    io_proc_data_create(
      41000,
      3
    )
  );

  data_scene->io_proc_data = io_proc_data;

  metil_audio_io_proc_add_with_data(
    &metil->audio,
    zoe_audio_io_proc_scene_menu_main,
    io_proc_data
  );

  rand_initialize(
    &data_scene->rand_parameters,
    &data_scene->rand_result,
    &data_scene->rand_source,
    4,
    rand_mode_bytes,
    rand_source_type_divisive
  );

  scene->poll = scene_menu_main_poll;
  scene->poll_input = scene_menu_main_poll_input;
  scene->destroy = scene_menu_main_destroy;

  data_scene->time_started = 0;

  menu_main_initialize(
    &data_scene->menu
  );

  scene->length_textures = 5;
  clic3_memory_reallocate_raw(
    &scene->textures,
    (
      sizeof(
        id<MTLTexture>
      ) *
      scene->length_textures
    )
  );

  scene->textures[
    textures_scene_menu_main_ground
  ] = (
    zoe_texture_static_generate(
      (struct math_c_vector2_unsigned_short_int) {
        .x = 300,
        .y = 300
      },
      metil->renderer_interface.metal_device
    )
  );

  scene->textures[
    textures_scene_menu_main_tree
  ] = (
    zoe_texture_static_generate(
      (struct math_c_vector2_unsigned_short_int) {
        .x = 300,
        .y = 300
      },
      metil->renderer_interface.metal_device
    )
  );

  for (
    unsigned int index_renderable = 0;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    metil_renderable_initialize_at_index(
      scene->renderables,
      index_renderable,
      metil_renderable_type_object
    );
  }

  struct metil_object* metil_object = (
    scene->renderables[
      0
    ].renderable
  );

  zoe_object_ground_initialize(
    metil_object,
    (struct math_c_vector3_float) {
      .x = 500.0f,
      .y = 5000.0f,
      .z = 500.0f
    },
    scene->textures[
      textures_scene_menu_main_ground
    ],
    scene->textures[
      textures_scene_menu_main_tree
    ],
    zoe_pipeline_index,
    metil->renderer_interface.metal_device
  );

  metil_object = (
    scene->renderables[
      1
    ].renderable
  );

  zoe_object_tree_initialize(
    metil,
    metil_object,
    0,
    (struct math_c_vector2_float) {
      .x = 1.0f,
      .y = 66.6f
    },
    scene->textures[
      textures_scene_menu_main_tree
    ],
    0,
    zoe_pipeline_index
  );

  metil_object = (
    scene->renderables[
      2
    ].renderable
  );

  metil_object_text_initialize(
    metil,
    metil_object,
    "zoe"
  );

  metil_object->position.y = (
    0.5f - (
      metil_object->mesh.size.y /
      4.0f
    )
  );

  metil_object = (
    scene->renderables[
      3
    ].renderable
  );

  metil_object_text_initialize(
    metil,
    metil_object,
    "enter"
  );

  metil_object->position.y = -(
    metil_object->mesh.size.y *
    6.0
  );

  metil_object = (
    scene->renderables[
      4
    ].renderable
  );

  metil_object_text_initialize(
    metil,
    metil_object,
    "exit"
  );

  metil_object->position.y = -(
    metil_object->mesh.size.y *
    10.0f
  );

  scene->player.position.y = (
    -metil_camera_height_default + 3.0f
  );

  scene->player.position.z = (
    -100.0f
  );

  scene->player.rotation.x = 0.3f;
}

void scene_menu_main_poll(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct zoe_data_zoe* zoe_data_zoe = (
    metil->data
  );

  float rotation_player_x_updated = (
    scene->player.rotation.x +
    (
      0.00001f *
      math_c_sine(
        (
          (
            (
              0.6f -
              (
                scene->player.rotation.x -
                0.3f
              )
            ) /
            0.6f
          ) *
          math_c_pi_half
        ),
        math_c_pi
      )
    ) *
    scene->time_delta
  );

  scene->player.rotation.x = (
    math_c_minimum_float(
      rotation_player_x_updated,
      0.9f
    )
  );

  struct scene_menu_main_data* data = (
    scene->data
  );

  struct metil_menu* menu = (
    &data->menu
  );

  rand_get(
    &data->rand_source,
    &data->rand_result,
    &data->rand_parameters
  );

  struct metil_renderer_data_object* data_object_enter = (
    (struct metil_object*) scene->renderables[3].renderable
  )->buffers_vertex[
    metil_object_buffer_default_index_data
  ].buffer.contents;

  struct metil_renderer_data_object* data_object_exit = (
    (struct metil_object*) scene->renderables[4].renderable
  )->buffers_vertex[
    metil_object_buffer_default_index_data
  ].buffer.contents;

  struct metil_renderer_data_object* data_object_menu_item_selected = data_object_enter;
  struct metil_renderer_data_object* data_object_menu_item = data_object_exit;

  if (
    menu->index_current ==
    0x01
  ) {
    data_object_menu_item_selected = data_object_exit;
    data_object_menu_item = data_object_enter;
  }

  data_object_menu_item_selected->noise = (
    8000 + (
      (
        data->rand_result.bytes[
          0x00
        ] *
        data->rand_result.bytes[
          0x01
        ]
      ) %
      1000
    )
  );

  data_object_menu_item->noise = (
    0x00
  );

  if (
    data->time_started !=
    0x00
  ) {
    unsigned long int time_delta = (
      scene->time -
      data->time_started
    );

    if (
      time_delta >= scene_menu_main_time_scene_transition
    ) {
      metil->rendering_properties.brightness = 0.0f;
      metil->rendering_properties.brightness_text = 0.0f;

      metil_scene_controller_scene_change(
        metil,
        metil->scene_controller,
        scene_id_intro_hill
      );

      return;
    } else {
      float brightness = (
        (float) (scene_menu_main_time_scene_transition - time_delta) /
        (float) scene_menu_main_time_scene_transition
      );

      metil->rendering_properties.brightness = (
        metil->configuration.rendering_properties.brightness *
        brightness
      );

      metil->rendering_properties.brightness_text = (
        metil->configuration.rendering_properties.brightness_text *
        brightness
      );
    }
  } else if (
    menu->index_selected != -1 &&
    menu->handled == 0
  ) {
    menu->handled = (
      0x01
    );

    switch (menu->index_selected) {
      case 0:
        metil_debug_log(
          metil->configuration.debug_log_level,
          "scene_menu_main:starting\n"
        );

        zoe_save_file_load(
          &zoe_data_zoe->save_files,
          &zoe_data_zoe->player,
          0x00
        );

        data->time_started = (
          scene->time
        );

        break;
      case 1:
        metil_debug_log(
          metil->configuration.debug_log_level,
          "scene_menu_main:exiting\n"
        );

        #if target_os_ios
        metil_termination_terminate(
          &metil->termination
        );
        exit(0);
        #else
        [[NSApplication sharedApplication] terminate: 0];
        #endif
        break;
    }
  }
}

void scene_menu_main_poll_input(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct scene_menu_main_data* scene_menu_main_data = (
    scene->data
  );

  struct metil_menu* menu = &(
    scene_menu_main_data->menu
  );

  metil_menu_poll_input(
    menu,
    &metil->input
  );
}

void scene_menu_main_destroy(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct scene_menu_main_data* data = (
    scene->data
  );

  struct io_proc_data* io_proc_data = (
    data->io_proc_data
  );

  metil_menu_destroy(
    &data->menu
  );

  io_proc_data->destroy = 1;

  rand_clean(
    &data->rand_result,
    &data->rand_source
  );

  metil_scene_destroy_default(
    metil,
    scene
  );
}
