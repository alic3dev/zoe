#include <zoe_audio/zoe_audio_io_proc_scene_menu_main.h>

#include <zoe_data/zoe_data_scene_menu_main.h>

#include <clic3_memory.h>

#include <metil.h>
#include <metil_audio/metil_audio_io_proc.h>
#include <metil_audio/metil_audio_io_proc_data.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>

#include <rand_clean.h>
#include <rand_functions.h>

metil_audio_io_proc_macro_definition(
  zoe_audio_io_proc_scene_menu_main
) {
  metil_audio_io_proc_macro_definition_initializer;

  struct io_proc_data* io_proc_data = (
    metil_audio_io_proc_data->data
  );

  if (
    io_proc_data->destroy ==
    0x01
  ) {
    metil_audio_io_proc_remove(
      &metil->audio,
      zoe_audio_io_proc_scene_menu_main
    );

    rand_clean(
      &io_proc_data->rand_result,
      &io_proc_data->rand_source
    );

    clic3_memory_free_raw(
      io_proc_data
    );

    return (
      0x00
    );
  }

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene = &(
    metil_scene_controller->scene
  );

  struct scene_menu_main_data* scene_menu_main_data = (
    metil_scene->data
  );

  float volume_multiplier = (
    0x01
  );

  if (
    scene_menu_main_data->time_started !=
    0x00
  ) {
    unsigned long int time_delta = (
      metil_scene->time -
      scene_menu_main_data->time_started
    );

    if (
      time_delta >=
      scene_menu_main_time_scene_transition
    ) {
      volume_multiplier = (
        0x00
      );
    } else {
      volume_multiplier = (
        (
          (float)
          (
            scene_menu_main_time_scene_transition -
            time_delta
          ) /
          (float)
          scene_menu_main_time_scene_transition
        ) *
        0.75f +
        0.25f
      );
    }
  }

  rand_get(
    &io_proc_data->rand_source,
    &io_proc_data->rand_result,
    &io_proc_data->rand_parameters
  );

  metil_audio_io_proc_macro_definition_frame_loop {
    unsigned int offset_byte = (
      index_frame *
      0x02
    );

    metil_audio_io_proc_macro_definition_frame_set(
      (float)
      (
        (
          io_proc_data->rand_result.bytes[
            offset_byte %
            20500
          ] *
          io_proc_data->rand_result.bytes[
            (
              offset_byte +
              0x01
            ) %
            20500
          ]
        ) %
        10000
      ) /
      100000.0f *
      volume_multiplier
    );
  }

  metil_audio_io_proc_macro_definition_return;
}
