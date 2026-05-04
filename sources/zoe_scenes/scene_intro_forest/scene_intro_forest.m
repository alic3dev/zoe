#include <zoe_scenes/scene_intro_forest/scene_intro_forest.h>

#include <zoe_attack_effects/zoe_attack_effects_controller.h>
#include <zoe_audio/io_proc_data.h>
#include <zoe_data/data_zoe.h>
#include <zoe_data/zoe_data_scene_intro_forest.h>
#include <zoe_enemies/zoe_enemy_auop.h>
#include <zoe_enemies/zoe_enemy_controller.h>
#include <zoe_group/group_text_with_backing.h>
#include <zoe_input/input_movement.h>
#include <zoe_loading_threads.h>
#include <zoe_model/model_zoe.h>
#include <zoe_object/object_ground.h>
#include <zoe_object/object_tree.h>
#include <zoe_pipeline_index.h>
#include <zoe_save_files/zoe_save_file.h>
#include <zoe_scenes/scene_id.h>
#include <zoe_textures/zoe_texture_static.h>
#include <zoe_weapons/zoe_weapon.h>
#include <zoe_weapons/zoe_weapon_knife.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <metil_audio/metil_audio_io_proc.h>
#include <metil_audio/metil_audio_io_proc_data.h>
#include <metil_collision/metil_collision_uncollide/metil_collision_uncollide_circular.h>
#include <metil_group.h>
#include <metil_object/metil_object.h>
#include <metil_object/metil_object_buffer.h>
#include <metil_paths/metil_paths.h>
#include <metil_rendering/metil_camera/metil_camera_mode.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>

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

void scene_intro_forest_initialize(
  struct zoe_loading_threads_data* zoe_loading_threads_data
) {
  struct metil* metil = (
    zoe_loading_threads_data->metil
  );

  struct metil_scene* scene = (
    zoe_loading_threads_data->scene
  );

  struct zoe_data_zoe* zoe_data_zoe = (
    metil->data
  );

  struct zoe_pipeline_index* zoe_pipeline_index = &(
    zoe_data_zoe->pipeline_index
  );

  struct zoe_data_player* zoe_data_player = (
    &zoe_data_zoe->player
  );

  static struct zoe_weapon* weapon_knife;

  weapon_knife = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_weapon
      )
    )
  );

  clic3_bytes_copy(
    weapon_knife,
    (
      (struct zoe_weapon*)
      &zoe_weapon_knife
    ),
    sizeof(
      struct zoe_weapon
    )
  );

  zoe_inventory_item_add(
    &zoe_data_player->inventory,
    zoe_inventory_item_type_weapon,
    weapon_knife
  );

  zoe_data_player->weapon_primary = (
    zoe_data_player->inventory.items[
      zoe_data_player->inventory.length_items -
      0x01
    ]
  );

  zoe_save_file_save(
    &zoe_data_zoe->save_files,
    zoe_data_player,
    0x00
  );

  metil->rendering_properties.brightness = (
    metil->configuration.rendering_properties.brightness
  );

  metil->rendering_properties.brightness_text = (
    metil->configuration.rendering_properties.brightness_text
  );

  metil->rendering_properties.camera.mode = (
    metil_camera_mode_third_person
  );

  metil->rendering_properties.camera.height = (
    metil_camera_height_default *
    0x04
  );

  metil_scene_initialize_with_renderables(
    metil,
    scene,
    scene_intro_forest_length_renderables
  );

  scene->player.rotation.x = (
    -0.3f
  );

  scene->player.data = (
    zoe_data_player
  );

  scene->player.poll_input = (
    zoe_input_movement
  );

  scene->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_data_scene_intro_forest
      )
    )
  );

  struct zoe_data_scene_intro_forest* zoe_data_scene_intro_forest = (
    scene->data
  );

  zoe_data_scene_intro_forest->io_proc_data = (
    io_proc_data_create(
      metil->audio.audio_output.sample_rate,
      0x01
    )
  );

  metil_audio_io_proc_add_with_data(
    &metil->audio,
    scene_intro_forest_io_proc,
    zoe_data_scene_intro_forest->io_proc_data
  );

  scene->poll = (
    scene_intro_forest_poll
  );

  scene->destroy = (
    scene_intro_forest_destroy
  );

  for (
    unsigned short int index_renderable = (
      0x00
    );
    (
      index_renderable <
      scene->length_renderables
    );
    ++index_renderable
  ) {
    switch (
      index_renderable
    ) {
      case scene_intro_forest_index_renderable_player:
      case scene_intro_forest_index_renderable_player_mirror: {
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_model
        );

        break;
      }
      case scene_intro_forest_index_renderable_group_attack_effects:
      case scene_intro_forest_index_renderable_group_enemies:
      case scene_intro_forest_index_renderable_group_trees: {
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_group
        );

        break;
      }
      case scene_intro_forest_index_renderable_group_text_place: {
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_group
        );

        group_text_with_backing_initialize(
          metil,
          scene->renderables[
            index_renderable
          ].renderable,
          "         "
        );

        break;
      }
      case scene_intro_forest_index_renderable_group_text_used: {
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_group
        );

        group_text_with_backing_initialize(
          metil,
          scene->renderables[
            index_renderable
          ].renderable,
          "!,,]\\..  2  6   %        t  532 9o         b e"
        );

        break;
      }
      case scene_intro_forest_index_renderable_group_text_this: {
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_group
        );

        group_text_with_backing_initialize(
          metil,
          scene->renderables[
            index_renderable
          ].renderable,
          "923#_2s 5o   m2   e t h   i n  g          225   m3#3o  r5  e           15   t  5 5h   .:  a  n    .    .      .         t  h\";   ^ i   s"
        );

        break;
      }
      case scene_intro_forest_index_renderable_ground:
      default: {
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_object
        );

        break;
      }
    }
  }

  zoe_attack_effects_controller_initialize(
    &zoe_data_scene_intro_forest->attack_effects_controller,
    scene->renderables[
      scene_intro_forest_index_renderable_group_attack_effects
    ].renderable,
    &scene->time_elapsed
  );

  zoe_enemy_controller_initialize(
    metil,
    &zoe_data_scene_intro_forest->enemy_controller,
    scene->renderables[
      scene_intro_forest_index_renderable_group_enemies
    ].renderable
  );

  scene->length_textures = (
    0x03
  );

  clic3_memory_reallocate_raw(
    &scene->textures,
    (
      sizeof(
        id<MTLTexture>
      ) *
      scene->length_textures
    )
  );

  MTKTextureLoader* texture_loader = [
    [
      MTKTextureLoader
      alloc
    ]
    initWithDevice: (
      metil->renderer_interface.metal_device
    )
  ];

  scene->textures[
    textures_scene_intro_forest_ground
  ] = (
    zoe_texture_static_generate(
      (struct math_c_vector2_unsigned_short_int) {
        .x = (
          0x012c
        ),
        .y = (
          0x012c
        )
      },
      metil->renderer_interface.metal_device
    )
  );

  zoe_loading_threads_progress_increase(
    zoe_loading_threads_data,
    0.1f
  );

  scene->textures[
    textures_scene_intro_forest_tree
  ] = (
    zoe_texture_static_generate(
      (struct math_c_vector2_unsigned_short_int) {
        .x = (
          0x012c
        ),
        .y = (
          0x012c
        )
      },
      metil->renderer_interface.metal_device
    )
  );

  zoe_loading_threads_progress_increase(
    zoe_loading_threads_data,
    0.1f
  );

  scene->textures[
    textures_scene_intro_forest_player
  ] = (
    zoe_texture_static_generate(
      (struct math_c_vector2_unsigned_short_int) {
        .x = (
          0x012c
        ),
        .y = (
          0x012c
        )
      },
      metil->renderer_interface.metal_device
    )
  );

  zoe_loading_threads_progress_increase(
    zoe_loading_threads_data,
    0.1f
  );

  [
    texture_loader
    release
  ];

  struct metil_model* metil_model_player = (
    scene->renderables[
      scene_intro_forest_index_renderable_player
    ].renderable
  );

  zoe_model_zoe_initialize(
    metil,
    metil_model_player,
    zoe_model_type_player,
    zoe_pipeline_index
  );

  struct metil_object* metil_object_player_body = &(
    metil_model_player->objects[
      0x00
    ]
  );

  scene->player.size.x = (
    metil_object_player_body->mesh.size.x /
    0x02
  );

  scene->player.size.y = (
    metil_object_player_body->mesh.size.y
  );

  scene->player.size.z = (
    metil_object_player_body->mesh.size.z /
    0x02
  );

  struct metil_model* metil_model_player_mirror = (
    scene->renderables[
      scene_intro_forest_index_renderable_player_mirror
    ].renderable
  );

  zoe_model_zoe_initialize(
    metil,
    metil_model_player_mirror,
    zoe_model_type_mirror,
    zoe_pipeline_index
  );

  struct metil_object* metil_object_ground = (
    scene->renderables[
      scene_intro_forest_index_renderable_ground
    ].renderable
  );

  zoe_object_ground_initialize(
    metil_object_ground,
    (struct math_c_vector3_float) {
      .x = (
        0x3e80
      ),
      .y = (
        0x03e8
      ),
      .z = (
        0x3e80
      )
    },
    scene->textures[
      textures_scene_intro_forest_ground
    ],
    scene->textures[
      textures_scene_intro_forest_tree
    ],
    zoe_pipeline_index,
    metil->renderer_interface.metal_device
  );

  zoe_loading_threads_progress_increase(
    zoe_loading_threads_data,
    0.1f
  );

  struct metil_group* metil_group_trees = (
    scene->renderables[
      scene_intro_forest_index_renderable_group_trees
    ].renderable
  );

  metil_group_allocate_length(
    metil_group_trees,
    scene_intro_forest_length_group_trees_renderables,
    metil_renderable_type_object
  );

  unsigned short int length_renderables_thread = (
    metil_group_trees->length /
    metil->system_information.cores_cpu
  );

  for (
    unsigned char index_thread = (
      0x00
    );
    (
      index_thread <
      metil->system_information.cores_cpu
    );
    ++index_thread
  ) {
    unsigned short int offset = (
      length_renderables_thread *
      index_thread
    );

    unsigned short int length;

    if (
      offset >= metil_group_trees->length
    ) {
      break;
    }

    if (
      index_thread == (
        metil->system_information.cores_cpu -
        0x01
      )
    ) {
      length = (
        metil_group_trees->length -
        offset
      );
    } else {
      length = (
        length_renderables_thread
      );
    }

    if (
      (
        offset +
        length
      ) >
      metil_group_trees->length
    ) {
      length = (
        metil_group_trees->length -
        offset
      );
    }

    static struct scene_intro_forest_tree_thread_data* scene_intro_forest_tree_thread_data;

    scene_intro_forest_tree_thread_data = (
      clic3_memory_allocate_raw(
        sizeof(
          struct scene_intro_forest_tree_thread_data
        )
      )
    );

    scene_intro_forest_tree_thread_data->group = (
      metil_group_trees
    );

    scene_intro_forest_tree_thread_data->size_bounds = (
      &metil_object_ground->mesh.size
    );

    scene_intro_forest_tree_thread_data->offset = (
      offset
    );

    scene_intro_forest_tree_thread_data->length = (
      length
    );

    zoe_loading_threads_spawn(
      zoe_loading_threads_data->loading_threads,
      zoe_scene_intro_forest_threaded_trees_initialization,
      scene_intro_forest_tree_thread_data
    );
  }

  for (
    unsigned char index_thread = (
      0x00
    );
    (
      index_thread <
      metil->system_information.cores_cpu
    );
    ++index_thread
  ) {
    pthread_join(
      zoe_loading_threads_data->loading_threads->threads[
        index_thread +
        0x01
      ],
      0x00
    );
  }

  zoe_loading_threads_progress_set(
    zoe_loading_threads_data,
    0x01
  );
}

void zoe_scene_intro_forest_threaded_trees_initialization(
  struct zoe_loading_threads_data* zoe_loading_threads_data
) {
  struct metil* metil = (
    zoe_loading_threads_data->metil
  );

  struct metil_scene* scene = (
    zoe_loading_threads_data->scene
  );

  struct scene_intro_forest_tree_thread_data* scene_intro_forest_tree_thread_data = (
    zoe_loading_threads_data->data
  );

  struct metil_group* metil_group_trees = (
    scene_intro_forest_tree_thread_data->group
  );

  struct math_c_vector3_float* size_bounds = (
    scene_intro_forest_tree_thread_data->size_bounds
  );

  struct zoe_data_zoe* zoe_data_zoe = (
    metil->data
  );

  struct zoe_pipeline_index* zoe_pipeline_index = &(
    zoe_data_zoe->pipeline_index
  );

  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  rand_initialize(
    &rand_parameters,
    &rand_result,
    &rand_source,
    (
      scene_intro_forest_tree_thread_data->length *
      0x05
    ),
    rand_mode_bytes,
    rand_source_type_divisive
  );

  rand_get(
    &rand_source,
    &rand_result,
    &rand_parameters
  );

  for (
    unsigned int index_renderable = scene_intro_forest_tree_thread_data->offset;
    index_renderable < (
      scene_intro_forest_tree_thread_data->offset +
      scene_intro_forest_tree_thread_data->length
    );
    ++index_renderable
  ) {
    struct metil_object* metil_object_tree = (
      metil_group_trees->renderables[
        index_renderable
      ]->renderable
    );

    metil_object_initialize(
      metil_object_tree
    );

    unsigned int offset_byte = (
      index_renderable *
      0x05
    );

    zoe_object_tree_initialize(
      metil,
      metil_object_tree,
      0,
      (struct math_c_vector2_float) {
        .x = (
          0x05
        ),
        .y = (
          0xfa
        )
      },
      scene->textures[
        textures_scene_intro_forest_tree
      ],
      (
        rand_result.bytes[
          offset_byte +
          0x04
        ] *
        index_renderable
      ),
      zoe_pipeline_index
    );

    metil_object_tree->position.x = (
      -(
        metil_object_tree->mesh.size.x /
        0x02
      ) + (
        (
          (
            (float)
            (
              (
                (
                  rand_result.bytes[
                    offset_byte
                  ] %
                  0xfe +
                  0x01
                ) *
                (
                  rand_result.bytes[
                    offset_byte +
                    0x02
                  ] %
                  0xfe +
                  0x01
                )
              ) %
              0x2710
            ) /
            0x1388
          ) -
          0x01
        ) *
        0.7f *
        (
          metil_object_tree->mesh.size.x - (
            size_bounds->x /
            0x02
          )
        )
      )
    );

    metil_object_tree->position.z = (
      -(
        metil_object_tree->mesh.size.z /
        0x02
      ) +
      (
        (
          (
            (float)
            (
              (
                (
                  rand_result.bytes[
                    offset_byte +
                    0x01
                  ] %
                  0xfe +
                  0x01
                ) *
                (
                  rand_result.bytes[
                    offset_byte +
                    0x03
                  ] %
                  0xfe +
                  0x01
                )
              ) %
              0x2710
            ) /
            0x1388
          ) -
          0x01
        ) *
        0.7f *
        (
          size_bounds->z -
          (
            size_bounds->z /
            0x02
          )
        )
      )
    );

    metil_object_tree->index_pipeline_render = (
      zoe_pipeline_index->tree
    );

    zoe_loading_threads_progress_increase(
      zoe_loading_threads_data,
      (
        (
          0x01 /
          (float)
          metil_group_trees->length
        ) *
        0.55f
      )
    );
  }

  rand_clean(
    &rand_result,
    &rand_source
  );
}

void scene_intro_forest_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_poll_default(
    metil,
    metil_scene
  );

  struct zoe_data_zoe* zoe_data_zoe = (
    metil->data
  );

  struct zoe_data_player* zoe_data_player = &(
    zoe_data_zoe->player
  );

  struct zoe_data_scene_intro_forest* zoe_data_scene_intro_forest = (
    metil_scene->data
  );

  struct zoe_enemy_controller* zoe_enemy_controller = &(
    zoe_data_scene_intro_forest->enemy_controller
  );

  zoe_attack_effects_controller_poll(
    metil,
    metil_scene,
    &zoe_data_scene_intro_forest->attack_effects_controller
  );

  if (
    zoe_data_player->actions &
    zoe_data_player_action_attack_primary
  ) {
    zoe_data_player->actions = (
      zoe_data_player->actions -
      zoe_data_player_action_attack_primary
    );

    zoe_enemy_controller_attack(
      metil,
      metil_scene,
      &metil_scene->player,
      zoe_enemy_controller,
      zoe_data_player->weapon_primary->item
    );

    struct zoe_attack_effect* zoe_attack_effect = (
      zoe_attack_effects_controller_add(
        &zoe_data_scene_intro_forest->attack_effects_controller
      )
    );

    zoe_attack_effect_slice_initialize(
      metil,
      zoe_attack_effect,
      &metil_scene->player.position,
      &metil_scene->player.rotation
    );
  }

  zoe_enemy_controller_poll(
    metil,
    metil_scene,
    zoe_enemy_controller
  );

  if (
    zoe_data_player->health <=
    0x00
  ) {
    zoe_data_player->health = (
      zoe_data_player->health_maximum
    );

    metil_scene_controller_scene_change(
      metil,
      metil->scene_controller,
      scene_id_intro_forest
    );

    return;
  }

  if (
    (
      *zoe_enemy_controller->length_enemies <
      (
        metil_scene->time_elapsed /
        0x03e8
      )
    ) &&
    (
      *zoe_enemy_controller->length_enemies <
      0x64
    )
  ) {
    zoe_enemy_controller_enemies_add_length(
      metil,
      zoe_enemy_controller,
      0x01
    );

    unsigned int index_enemy = (
      *zoe_enemy_controller->length_enemies -
      0x01
    );

    struct metil_renderable* metil_renderable_enemy = (
      zoe_enemy_controller->group_enemies->renderables[
        index_enemy
      ]
    );

    struct zoe_enemy* zoe_enemy_auop = (
      zoe_enemy_controller->enemies[
        index_enemy
      ]
    );

    zoe_enemy_auop_initialize(
      metil,
      zoe_enemy_auop,
      metil_renderable_enemy,
      &zoe_data_scene_intro_forest->attack_effects_controller
    );

    zoe_enemy_auop->position->x = (
      metil_scene->player.position.x +
      (
        metil_scene->time_elapsed %
        0x20
      )
    );

    zoe_enemy_auop->position->z = (
      metil_scene->player.position.z +
      (
        (
          metil_scene->time_elapsed +
          0x45
        ) %
        0x20
      ) *
      (
        (
          metil_scene->time_delta %
          0x02
        ) ==
        0x00
        ? -0x01
        :  0x01
      )
    );
  }

  struct metil_group* metil_group_trees = (
    metil_scene->renderables[
      scene_intro_forest_index_renderable_group_trees
    ].renderable
  );

  for (
    unsigned short int index_renderable = 0;
    index_renderable < metil_group_trees->length;
    ++index_renderable
  ) {
    struct metil_object* metil_object_tree = (
      metil_group_trees->renderables[
        index_renderable
      ]->renderable
    );

    metil_collision_player_object_uncollide_circular_xz(
      metil_object_tree,
      &metil_scene->player
    );
  }

  struct metil_group* metil_group_text_place = (
    metil_scene->renderables[
      scene_intro_forest_index_renderable_group_text_place
    ].renderable
  );

  struct metil_group* metil_group_text_used = (
    metil_scene->renderables[
      scene_intro_forest_index_renderable_group_text_used
    ].renderable
  );

  struct metil_group* metil_group_text_this = (
    metil_scene->renderables[
      scene_intro_forest_index_renderable_group_text_this
    ].renderable
  );

  if (
    metil_scene->time_elapsed <
    0x1770
  ) {
    metil_group_text_place->visible = (
      0x01
    );
  } else if (
    metil_scene->time_elapsed <
    0x2ee0
  ) {
    metil_group_text_place->visible = (
      0x00
    );

    metil_group_text_used->visible = (
      0x01
    );
  } else if (
    metil_scene->time_elapsed <
    0x5dc0
  ) {
    metil_group_text_place->visible = (
      0x00
    );

    metil_group_text_used->visible = (
      0x00
    );

    metil_group_text_this->visible = (
      0x01
    );
  } else {
    metil_group_text_place->visible = (
      0x00
    );

    metil_group_text_used->visible = (
      0x00
    );

    metil_group_text_this->visible = (
      0x00
    );
  }
}

void scene_intro_forest_destroy(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  struct zoe_data_scene_intro_forest* zoe_data_scene_intro_forest = (
    metil_scene->data
  );

  zoe_attack_effects_controller_destroy(
    &zoe_data_scene_intro_forest->attack_effects_controller
  );

  zoe_enemy_controller_destroy(
    metil,
    &zoe_data_scene_intro_forest->enemy_controller
  );

  struct io_proc_data* io_proc_data = (
    zoe_data_scene_intro_forest->io_proc_data
  );

  io_proc_data->destroy = (
    0x01
  );

  metil_scene_destroy_default(
    metil,
    metil_scene
  );
}

#if target_os_ios
int scene_intro_forest_io_proc(
  unsigned char silence,
  const AudioTimeStamp* _Nonnull timestamp,
  unsigned int frame_count,
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
    io_proc_data->destroy ==
    0x01
  ) {
    metil_audio_io_proc_remove(
      &metil_audio_io_proc_data->metil->audio,
      scene_intro_forest_io_proc
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

  rand_get(
    &io_proc_data->rand_source,
    &io_proc_data->rand_result,
    &io_proc_data->rand_parameters
  );

  for (
    unsigned long int index_buffer = (
      0x00
    );
    (
      index_buffer <
      output_data->mNumberBuffers
    );
    ++index_buffer
  ) {
    AudioBuffer audio_buffer_current = (
      output_data->mBuffers[
        index_buffer
      ]
    );

    float* buffer_out = (
      audio_buffer_current.mData
    );

    unsigned long int count_channel_out = (
      audio_buffer_current.mNumberChannels
    );

    for (
      unsigned int index_frame = (
        0x00
      );
      (
        index_frame <
        frame_count
      );
      ++index_frame
    ) {
      unsigned long int channel = (
        index_frame %
        count_channel_out
      );

      unsigned int offset_byte = (
        index_frame *
        0x02
      );

      if (
        channel ==
        0x00
      ) {
        buffer_out[
          index_frame
        ] = (
          (
            (float)
            (
              (
                io_proc_data->rand_result.bytes[
                  offset_byte %
                  0x5014
                ] *
                io_proc_data->rand_result.bytes[
                  (
                    offset_byte +
                    0x01
                  ) %
                  0x5014
                ]
              ) %
              0x2710
            )
          ) /
          0x0186a0
        );
      } else {
        buffer_out[
          index_frame
        ] = (
          buffer_out[
            index_frame -
            channel
          ]
        );
      }
    }
  }

  return (
    0x00
  );
}
#else
OSStatus scene_intro_forest_io_proc(
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
    io_proc_data->destroy ==
    0x01
  ) {
    metil_audio_io_proc_remove(
      &metil_audio_io_proc_data->metil->audio,
      scene_intro_forest_io_proc
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

  rand_get(
    &io_proc_data->rand_source,
    &io_proc_data->rand_result,
    &io_proc_data->rand_parameters
  );

  for (
    unsigned long int index_buffer = (
      0x00
    );
    (
      index_buffer <
      list_buffer_audio_out->mNumberBuffers
    );
    ++index_buffer
  ) {
    AudioBuffer audio_buffer_current = (
      list_buffer_audio_out->mBuffers[
        index_buffer
      ]
    );

    float* buffer_out = (
      audio_buffer_current.mData
    );

    unsigned long int size_buffer_out = (
      audio_buffer_current.mDataByteSize /
      sizeof(
        float
      )
    );

    unsigned long int count_channel_out = (
      audio_buffer_current.mNumberChannels
    );

    for (
      unsigned long int index_buffer_out = (
        0x00
      );
      (
        index_buffer_out <
        size_buffer_out
      );
      ++index_buffer_out
    ) {
      unsigned long int channel = (
        index_buffer_out %
        count_channel_out
      );

      unsigned int offset_byte = (
        index_buffer_out *
        0x02
      );

      if (
        channel ==
        0x00
      ) {
        buffer_out[
          index_buffer_out
        ] = (
          (
            (float)
            (
              (
                io_proc_data->rand_result.bytes[
                  offset_byte %
                  0x5014
                ] *
                io_proc_data->rand_result.bytes[
                  (
                    offset_byte +
                    0x01
                  ) %
                  0x5014
                ]
              ) %
              0x2710
            )
          ) /
          0x0186a0
        );
      } else {
        buffer_out[
          index_buffer_out
        ] = buffer_out[
          index_buffer_out -
          channel
        ];
      }
    }
  }

  return (
    0x00
  );
}
#endif
