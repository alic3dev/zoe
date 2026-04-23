#include <scenes/scene_menu_main.h>

#include <data/data_zoe.h>
#include <menus/menu_main.h>
#include <object/object_ground.h>
#include <object/object_tree.h>
#include <scenes/scene_id.h>
#include <textures/zoe_texture_static.h>
#include <zoe_pipeline_index.h>

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

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif
const unsigned long int scene_menu_main_time_scene_transition = (
  3333
);

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
    5
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
    scene_menu_main_io_proc,
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
  scene->textures = realloc(
    scene->textures,
    sizeof(
      id<MTLTexture>
    ) *
    scene->length_textures
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
    menu->index_current == 1
  ) {
    data_object_menu_item_selected = data_object_exit;
    data_object_menu_item = data_object_enter;
  }

  data_object_menu_item_selected->noise = (
    8000 + ((
      data->rand_result.bytes[0] *
      data->rand_result.bytes[1]
    ) % 1000)
  );

  data_object_menu_item->noise = 0;

  if (
    data->time_started != 0
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
    menu->handled = 1;

    switch (menu->index_selected) {
      case 0:
        metil_debug_log(
          metil->configuration.debug_log_level,
          "scene_menu_main:starting\n"
        );

        data->time_started = scene->time;
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

#if target_os_ios
int scene_menu_main_io_proc(
  unsigned char silence,
  const AudioTimeStamp* _Nonnull timestamp,
  AVAudioFrameCount frame_count,
  AudioBufferList* _Nonnull output_data,
  void* data
) {
  struct metil_audio_io_proc_data* metil_audio_io_proc_data = (
    data
  );

  struct io_proc_data* io_proc_data = (
    metil_audio_io_proc_data->data
  );

  if (
    io_proc_data->destroy == 1
  ) {
    metil_audio_io_proc_remove(
      &metil_audio_io_proc_data->metil->audio,
      scene_menu_main_io_proc
    );

    rand_clean(
      &io_proc_data->rand_result,
      &io_proc_data->rand_source
    );

    free(
      io_proc_data
    );

    return 0;
  }

  struct metil_scene_controller* metil_scene_controller = (
    metil_audio_io_proc_data->metil->scene_controller
  );

  struct metil_scene* metil_scene = &(
    metil_scene_controller->scene
  );

  struct scene_menu_main_data* scene_menu_main_data = (
    metil_scene->data
  );

  float volume_multiplier = (
    1.0f
  );

  if (
    scene_menu_main_data->time_started != 0
  ) {
    unsigned long int time_delta = (
      metil_scene->time -
      scene_menu_main_data->time_started
    );

    if (
      time_delta >= scene_menu_main_time_scene_transition
    ) {
      volume_multiplier = (
        0.0f
      );
    } else {
      volume_multiplier = (
        (
          (float) (scene_menu_main_time_scene_transition - time_delta) /
          (float) scene_menu_main_time_scene_transition
        ) *
        0.75 +
        0.25f
      );
    }
  }

  rand_get(
    &io_proc_data->rand_source,
    &io_proc_data->rand_result,
    &io_proc_data->rand_parameters
  );

  for (
    unsigned long int index_buffer = 0;
    index_buffer < output_data->mNumberBuffers;
    ++index_buffer
  ) {
    AudioBuffer audio_buffer_current = output_data->mBuffers[
      index_buffer
    ];

    float* buffer_out = audio_buffer_current.mData;
    unsigned long int count_channel_out = audio_buffer_current.mNumberChannels;

    for (
      unsigned int index_frame = 0;
      index_frame < frame_count;
      ++index_frame
    ) {
      unsigned long int channel = (
        index_frame %
        count_channel_out
      );

      unsigned int offset_byte = (
        index_frame *
        2
      );

      buffer_out[
        index_frame
      ] = (
        (
          (float) (
            (
              io_proc_data->rand_result.bytes[
                offset_byte %
                20500
              ] *
              io_proc_data->rand_result.bytes[
                (
                  offset_byte +
                  1
                ) %
                20500
              ]
            ) %
            10000
          )
        ) /
        100000.0f *
        volume_multiplier
      );
    }
  }

  return 0;
}
#else
OSStatus scene_menu_main_io_proc(
  AudioObjectID id_audio_object,
  const AudioTimeStamp* time_stamp_audio,
  const AudioBufferList* list_buffer_audio_in,
  const AudioTimeStamp* time_stamp_audio_in,
  AudioBufferList* list_buffer_audio_out,
  const AudioTimeStamp* time_stamp_audio_out,
  void* data
) {
  struct metil_audio_io_proc_data* metil_audio_io_proc_data = (
    data
  );

  struct io_proc_data* io_proc_data = (
    metil_audio_io_proc_data->data
  );

  if (
    io_proc_data->destroy == 1
  ) {
    metil_audio_io_proc_remove(
      &metil_audio_io_proc_data->metil->audio,
      scene_menu_main_io_proc
    );

    rand_clean(
      &io_proc_data->rand_result,
      &io_proc_data->rand_source
    );

    free(
      io_proc_data
    );

    return 0;
  }

  struct metil_scene_controller* metil_scene_controller = (
    metil_audio_io_proc_data->metil->scene_controller
  );

  struct metil_scene* metil_scene = &(
    metil_scene_controller->scene
  );

  struct scene_menu_main_data* scene_menu_main_data = (
    metil_scene->data
  );

  float volume_multiplier = (
    1.0f
  );

  if (
    scene_menu_main_data->time_started != 0
  ) {
    unsigned long int time_delta = (
      metil_scene->time -
      scene_menu_main_data->time_started
    );

    if (
      time_delta >= scene_menu_main_time_scene_transition
    ) {
      volume_multiplier = (
        0.0f
      );
    } else {
      volume_multiplier = (
        (
          (float) (scene_menu_main_time_scene_transition - time_delta) /
          (float) scene_menu_main_time_scene_transition
        ) *
        0.75 +
        0.25f
      );
    }
  }

  rand_get(
    &io_proc_data->rand_source,
    &io_proc_data->rand_result,
    &io_proc_data->rand_parameters
  );

  for (
    unsigned long int index_buffer = 0;
    index_buffer < list_buffer_audio_out->mNumberBuffers;
    ++index_buffer
  ) {
    AudioBuffer audio_buffer_current = list_buffer_audio_out->mBuffers[index_buffer];

    float* buffer_out = audio_buffer_current.mData;
    unsigned long int size_buffer_out = audio_buffer_current.mDataByteSize / sizeof(float);
    unsigned long int count_channel_out = audio_buffer_current.mNumberChannels;

    for (
      unsigned long int index_buffer_out = 0;
      index_buffer_out < size_buffer_out;
      ++index_buffer_out
    ) {
      unsigned long int channel = index_buffer_out % count_channel_out;
      unsigned int offset_byte = (
        index_buffer_out *
        2
      );

      buffer_out[
        index_buffer_out
      ] = (
        (
          (float) (
            (
              io_proc_data->rand_result.bytes[
                offset_byte %
                20500
              ] *
              io_proc_data->rand_result.bytes[
                (
                  offset_byte +
                  1
                ) %
                20500
              ]
            ) %
            10000
          )
        ) /
        100000.0f *
        volume_multiplier
      );
    }
  }

  return 0;
}
#endif
