#include <scenes/scene_intro_hill.h>

#include <audio/io_proc_data.h>
#include <calculations/hill_y_value.h>
#include <data/data_player.h>
#include <data/data_zoe.h>
#include <group/group_text_with_backing.h>
#include <input/input_movement.h>
#include <mesh/mesh_hill.h>
#include <model/model_zoe.h>
#include <object/object_hill.h>
#include <object/object_tree.h>
#include <scenes/scene_id.h>
#include <textures/zoe_texture_hill_lighting.h>
#include <textures/zoe_texture_static.h>
#include <zoe_pipeline_index.h>

#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metil.h>
#include <metil_audio/metil_audio_io_proc.h>
#include <metil_audio/metil_audio_io_proc_data.h>
#include <metil_collision/metil_collision_uncollide/metil_collision_uncollide_circular.h>
#include <metil_group.h>
#include <metil_mesh/metil_mesh_mushroom.h>
#include <metil_object/metil_object.h>
#include <metil_object/metil_object_buffer.h>
#include <metil_object/metil_object_text.h>
#include <metil_paths/metil_paths.h>
#include <metil_rendering/metil_camera/metil_camera_mode.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>

#include <clic3_memory.h>

#include <math_c_absolute.h>
#include <math_c_maximum.h>
#include <math_c_minimum.h>
#include <math_c_vector.h>
#include <math_c_vector_distance.h>

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

void scene_intro_hill_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct zoe_data_zoe* zoe_data_zoe = (
    metil->data
  );

  struct zoe_pipeline_index* zoe_pipeline_index = &(
    zoe_data_zoe->pipeline_index
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
    4.0f
  );

  metil_scene_initialize_with_renderables(
    metil,
    scene,
    scene_intro_hill_length_renderables
  );

  scene->player.poll_input = (
    zoe_input_movement
  );

  scene->player.data = (
    &zoe_data_zoe->player
  );

  scene->player.rotation.x = -0.3f;

  scene->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct scene_intro_hill_data
      )
    )
  );

  struct scene_intro_hill_data* data_scene = (
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
    scene_intro_hill_io_proc,
    io_proc_data
  );

  scene->poll = scene_intro_hill_poll;
  scene->destroy = scene_intro_hill_destroy;

  for (
    unsigned short int index_renderable = 0;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    switch (
      index_renderable
    ) {
      case scene_intro_hill_index_renderable_player:
      case scene_intro_hill_index_renderable_player_mirror:
      case scene_intro_hill_index_renderable_zoe:
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_model
        );

        break;
      case scene_intro_hill_index_renderable_group_mushrooms:
      case scene_intro_hill_index_renderable_group_text: {
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_group
        );

        break;
      }
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

  struct metil_group* metil_group_mushrooms = (
    scene->renderables[
      scene_intro_hill_index_renderable_group_mushrooms
    ].renderable
  );

  metil_group_add_length_initialize(
    metil_group_mushrooms,
    333,
    metil_renderable_type_object
  );

  for (
    unsigned short int index_mushroom = 0;
    index_mushroom < metil_group_mushrooms->length;
    ++index_mushroom
  ) {
    struct metil_object* metil_object_mushroom = (
      metil_group_mushrooms->renderables[
        index_mushroom
      ]->renderable
    );

    metil_mesh_mushroom_initialize(
      &metil_object_mushroom->mesh,
      (struct math_c_vector3_float) {
        .x = 10.0f,
        .y = 10.0f,
        .z = 10.0f
      },
      (struct math_c_vector2_unsigned_short_int) {
        .x = 100,
        .y = 100
      }
    );

    float angle = (
      (float)
      index_mushroom /
      (
        (float)
        metil_group_mushrooms->length /
        50.0f
      ) *
      math_c_pi
    );

    float distance = (
      (float)
      index_mushroom /
      (
        (float)
        metil_group_mushrooms->length /
        10.0f
      ) *
      100.0f +
      200.0f
    );

    metil_object_mushroom->index_pipeline_render = (
      zoe_pipeline_index->mushroom
    );

    metil_object_mushroom->position.x = (
      math_c_sine(
        angle,
        math_c_pi
      ) *
      distance
    );

    metil_object_mushroom->position.z = (
      math_c_cosine(
        angle,
        math_c_pi
      ) *
      distance
    );

    struct math_c_vector2_float position_percentage = {
      .x = (
        math_c_absolute_float(
          metil_object_mushroom->position.x / (
            length_vertices_hill_x -
            1
          )
        ) /
        0x02
      ),
      .y = (
        math_c_absolute_float(
          metil_object_mushroom->position.z / (
            length_vertices_hill_y -
            1
          )
        ) /
        0x02
      )
    };

    metil_object_mushroom->position.y = (
      hill_y_value_get(
        &position_percentage
      ) +
      metil_object_mushroom->mesh.size.y /
      2.0f
    );

    metil_object_buffers_initialize(
      metil_object_mushroom,
      metil->renderer_interface.metal_device
    );
  }

  scene->length_textures = (
    scene_intro_hill_length_textures
  );

  clic3_memory_reallocate_raw(
    &scene->textures,
    sizeof(
      id<MTLTexture>
    ) *
    scene->length_textures
  );

  scene->textures[
    scene_intro_hill_textures_hill
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

  scene->textures[
    scene_intro_hill_textures_tree
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

  scene->textures[
    scene_intro_hill_textures_player
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

  scene->textures[
    scene_intro_hill_textures_lighting
  ] = (
    zoe_texture_hill_lighting_generate(
      metil_group_mushrooms,
      metil->renderer_interface.metal_device
    )
  );

  struct metil_model* metil_model_player = (
    scene->renderables[
      scene_intro_hill_index_renderable_player
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
      scene_intro_hill_index_renderable_player_mirror
    ].renderable
  );

  zoe_model_zoe_initialize(
    metil,
    metil_model_player_mirror,
    zoe_model_type_mirror,
    zoe_pipeline_index
  );

  struct metil_model* metil_model_zoe = (
    scene->renderables[
      scene_intro_hill_index_renderable_zoe
    ].renderable
  );

  zoe_model_zoe_initialize(
    metil,
    metil_model_zoe,
    zoe_model_type_statue,
    zoe_pipeline_index
  );

  struct metil_object* metil_object_hill = (
    scene->renderables[
      scene_intro_hill_index_renderable_hill
    ].renderable
  );

  zoe_object_hill_initialize(
    metil_object_hill,
    scene->textures[
      scene_intro_hill_textures_hill
    ],
    scene->textures[
      scene_intro_hill_textures_tree
    ],
    scene->textures[
      scene_intro_hill_textures_lighting
    ],
    zoe_pipeline_index,
    metil->renderer_interface.metal_device
  );

  struct metil_object* metil_object_tree_zoe = (
    scene->renderables[
      scene_intro_hill_index_renderable_tree_zoe
    ].renderable
  );

  zoe_object_tree_initialize(
    metil,
    metil_object_tree_zoe,
    0x00,
    (struct math_c_vector2_float) {
      .x = 33.3f,
      .y = 333.5f
    },
    scene->textures[
      scene_intro_hill_textures_tree
    ],
    0xd5,
    zoe_pipeline_index
  );

  metil_object_tree_zoe->position.y = 100.0f;
  metil_object_tree_zoe->position.z = 1666.1f;

  struct metil_object* metil_object_tree_zoe_mirror = (
    scene->renderables[
      scene_intro_hill_index_renderable_tree_zoe_mirror
    ].renderable
  );

  zoe_object_tree_initialize(
    metil,
    metil_object_tree_zoe_mirror,
    &metil_object_tree_zoe->mesh,
    (struct math_c_vector2_float) {
      .x = 33.3f,
      .y = 333.5f
    },
    scene->textures[
      scene_intro_hill_textures_tree
    ],
    312,
    zoe_pipeline_index
  );

  metil_object_tree_zoe_mirror->position.y = 100.0f;
  metil_object_tree_zoe_mirror->position.z = -1666.1f;

  struct metil_group* metil_group_text = (
    scene->renderables[
      scene_intro_hill_index_renderable_group_text
    ].renderable
  );

  for (
    unsigned char index_group_renderable = 0;
    index_group_renderable < scene_intro_hill_length_group_text_renderables;
    ++index_group_renderable
  ) {
    metil_group_add_initialize(
      metil_group_text,
      metil_renderable_type_group
    );

    struct metil_group* metil_group_text_group = (
      metil_group_text->renderables[
        index_group_renderable
      ]->renderable
    );

    switch (
      index_group_renderable
    ) {
      case scene_intro_hill_index_renderable_group_text_index_renderable_bounds: {
        group_text_with_backing_initialize(
          metil,
          metil_group_text_group,
          "there's  nothing  out  there      .       .     .   .  . . ...."
        );

        break;
      }
      case scene_intro_hill_index_renderable_group_text_index_renderable_tree_hello: {
        group_text_with_backing_initialize(
          metil,
          metil_group_text_group,
          "h    e  l   l     o       .               .            ."
        );

        break;
      }
      case scene_intro_hill_index_renderable_group_text_index_renderable_tree_not_yours: {
        group_text_with_backing_initialize(
          metil,
          metil_group_text_group,
          "t h i s,     i s   n o t     yo u r      t r e e"

           "i wrote this its all my tree <3 "
        );

        break;
      }
    }
  }
}

void scene_intro_hill_poll(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct scene_intro_hill_data* scene_intro_hill_data = (
    scene->data
  );

  metil_scene_poll_default(
    metil,
    scene
  );

  struct zoe_data_player* zoe_data_player = (
    scene->player.data
  );

  struct math_c_vector2_float position_player_bounds_minimum = {
    .x = (
      scene->player.position.x -
      scene->player.size.x
    ),
    .y = (
      scene->player.position.z -
      scene->player.size.z
    )
  };

  struct math_c_vector2_float position_player_bounds_maximum = {
    .x = (
      scene->player.position.x +
      scene->player.size.x
    ),
    .y = (
      scene->player.position.z +
      scene->player.size.z
    )
  };

  if (
    position_player_bounds_maximum.x > length_vertices_hill_x
  ) {
    scene->player.position.x = (
      length_vertices_hill_x -
      scene->player.size.x
    );
  } else if (
    position_player_bounds_minimum.x < -length_vertices_hill_x
  ) {
    scene->player.position.x = (
      -length_vertices_hill_x +
      scene->player.size.x
    );
  }

  if (
    position_player_bounds_maximum.y > length_vertices_hill_y
  ) {
    scene->player.position.z = (
      length_vertices_hill_y -
      scene->player.size.z
    );
  } else if (
    position_player_bounds_minimum.y < -length_vertices_hill_y
  ) {
    scene->player.position.z = (
      -length_vertices_hill_y +
      scene->player.size.z
    );
  }

  struct metil_group* metil_group_text = (
    scene->renderables[
      scene_intro_hill_index_renderable_group_text
    ].renderable
  );

  struct metil_group* metil_group_text_bounds = (
    metil_group_text->renderables[
      scene_intro_hill_index_renderable_group_text_index_renderable_bounds
    ]->renderable
  );

  float distance_proximity_text_bounds = (
    math_c_minimum_float(
      math_c_minimum_float(
        length_vertices_hill_x -
        scene->player.position.x,
        math_c_absolute_float(
          -length_vertices_hill_x -
          scene->player.position.x
        )
      ),
      math_c_minimum_float(
        length_vertices_hill_y -
        scene->player.position.z,
        math_c_absolute_float(
          -length_vertices_hill_y -
          scene->player.position.z
        )
      )
    )
  );

  group_text_with_backing_visibility_set(
    metil_group_text_bounds,
    distance_proximity_text_bounds,
    100.0f
  );

  struct metil_model* metil_model_player = (
    scene->renderables[
      scene_intro_hill_index_renderable_player
    ].renderable
  );

  struct metil_model* metil_model_player_mirror = (
    scene->renderables[
      scene_intro_hill_index_renderable_player_mirror
    ].renderable
  );

  struct metil_model* metil_model_zoe = (
    scene->renderables[
      scene_intro_hill_index_renderable_zoe
    ].renderable
  );

  struct metil_object* metil_object_tree;

  for (
    unsigned char index_tree = 0;
    index_tree < 2;
    ++index_tree
  ) {
    struct metil_group* metil_group_text_tree;

    switch (
      index_tree
    ) {
      case 0: {
        metil_object_tree = (
          scene->renderables[
            scene_intro_hill_index_renderable_tree_zoe
          ].renderable
        );

        metil_group_text_tree = (
          metil_group_text->renderables[
            scene_intro_hill_index_renderable_group_text_index_renderable_tree_hello
          ]->renderable
        );

        break;
      }
      default:
      case 1: {
        metil_object_tree = (
          scene->renderables[
            scene_intro_hill_index_renderable_tree_zoe_mirror
          ].renderable
        );

        metil_group_text_tree = (
          metil_group_text->renderables[
            scene_intro_hill_index_renderable_group_text_index_renderable_tree_not_yours
          ]->renderable
        );

        break;
      }
    }

    metil_collision_player_object_uncollide_circular_xz(
      metil_object_tree,
      &scene->player
    );

    if (
      metil_group_text_bounds->visible == 0
    ) {
      float distance_proximity_text_tree = (
        math_c_vector3_distance_float(
          &scene->player.position,
          &metil_object_tree->position
        )
      );

      group_text_with_backing_visibility_minimum_maximum_set(
        metil_group_text_tree,
        distance_proximity_text_tree,
        0x01f4,
        0x00c8
      );

      if (
        (
          index_tree ==
          0x00
        ) &&
        (
          metil_group_text_tree->visible !=
          0x00
        ) &&
        (
          zoe_data_player->actions &
          zoe_data_player_action_select
        )
      ) {
        zoe_data_player->actions = (
          zoe_data_player->actions ^
          zoe_data_player_action_select
        );

        metil_scene_controller_scene_change(
          metil,
          metil->scene_controller,
          scene_id_intro_forest
        );

        return;
      }
    } else {
      metil_group_text_tree->visible = (
        0x00
      );
    }
  }

  struct math_c_vector2_float position_percentage = {
    .x = (
      math_c_absolute_float(
        scene->player.position.x / (
          length_vertices_hill_x -
          1
        )
      ) / 2.0f
    ),
    .y = (
      math_c_absolute_float(
        scene->player.position.z / (
          length_vertices_hill_y -
          1
        )
      ) / 2.0f
    )
  };

  scene->player.position_y_floor = (
    hill_y_value_get(
      &position_percentage
    )
  );
}

void scene_intro_hill_destroy(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  struct scene_intro_hill_data* scene_intro_hill_data = (
    metil_scene->data
  );

  struct io_proc_data* io_proc_data = (
    scene_intro_hill_data->io_proc_data
  );

  io_proc_data->destroy = 1;

  metil_scene_destroy_default(
    metil,
    metil_scene
  );
}

#if target_os_ios
int scene_intro_hill_io_proc(
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
    io_proc_data->destroy == 1
  ) {
    metil_audio_io_proc_remove(
      &metil_audio_io_proc_data->metil->audio,
      scene_intro_hill_io_proc
    );

    rand_clean(
      &io_proc_data->rand_result,
      &io_proc_data->rand_source
    );

    clic3_memory_free_raw(
      io_proc_data
    );

    return 0;
  }

  float volume_multiplier = (
    0.25f
  );

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
OSStatus scene_intro_hill_io_proc(
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
      scene_intro_hill_io_proc
    );

    rand_clean(
      &io_proc_data->rand_result,
      &io_proc_data->rand_source
    );

    clic3_memory_free_raw(
      io_proc_data
    );

    return 0;
  }

  float volume_multiplier = (
    0.25f
  );

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
    unsigned long int size_buffer_out = (
      audio_buffer_current.mDataByteSize /
      sizeof(float)
    );
    unsigned long int count_channel_out = audio_buffer_current.mNumberChannels;

    for (
      unsigned long int index_buffer_out = 0;
      index_buffer_out < size_buffer_out;
      ++index_buffer_out
    ) {
      unsigned long int channel = (
        index_buffer_out %
        count_channel_out
      );
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
