#include <scenes/scene_intro_forest/scene_intro_forest.h>

#include <audio/io_proc_data.h>
#include <data/data_zoe.h>
#include <input/input_movement.h>
#include <model/model_player.h>
#include <object/object_ground.h>
#include <object/object_tree.h>
#include <scenes/scene_id.h>
#include <zoe_loading_threads.h>
#include <zoe_pipeline_index.h>

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

#include <stdlib.h>

void scene_intro_forest_initialize(
  struct zoe_loading_threads_data* zoe_loading_threads_data
) {
  struct metil* metil = (
    zoe_loading_threads_data->metil
  );

  struct metil_scene* scene = (
    zoe_loading_threads_data->scene
  );

  struct data_zoe* data_zoe = (
    metil->data
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
    scene_intro_forest_length_renderables
  );

  scene->player.rotation.x = -0.3f;
  scene->player.data = (
    &data_zoe->player
  );

  scene->player.poll_input = (
    zoe_input_movement
  );

  scene->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct scene_intro_forest_data
      )
    )
  );

  struct scene_intro_forest_data* data_scene = (
    scene->data
  );

  struct io_proc_data* io_proc_data = (
    io_proc_data_create(
      41000,
      1
    )
  );

  data_scene->io_proc_data = io_proc_data;

  metil_audio_io_proc_add_with_data(
    &metil->audio,
    scene_intro_forest_io_proc,
    io_proc_data
  );

  scene->poll = scene_intro_forest_poll;
  scene->destroy = scene_intro_forest_destroy;

  for (
    unsigned short int index_renderable = 0;
    index_renderable < scene->length_renderables;
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
      case scene_intro_forest_index_renderable_group_trees: {
        metil_renderable_initialize_at_index(
          scene->renderables,
          index_renderable,
          metil_renderable_type_group
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

  scene->length_textures = 3;
  scene->textures = realloc(
    scene->textures,
    sizeof(id<MTLTexture>) *
    scene->length_textures
  );

  MTKTextureLoader* texture_loader = [
    [MTKTextureLoader alloc]
    initWithDevice: (
      metil->renderer_interface.metal_device
    )
  ];

  scene->textures[
    textures_scene_intro_forest_ground
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"0028.png"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: metil->paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*) 0
    error: (void*) 0
  ];

  zoe_loading_threads_progress_increase(
    zoe_loading_threads_data,
    0.1f
  );

  scene->textures[
    textures_scene_intro_forest_tree
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"zoef.png"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: metil->paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*) 0
    error: (void*) 0
  ];

  zoe_loading_threads_progress_increase(
    zoe_loading_threads_data,
    0.1f
  );

  scene->textures[
    textures_scene_intro_forest_player
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"zoef.png"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: metil->paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*) 0
    error: (void*) 0
  ];

  zoe_loading_threads_progress_increase(
    zoe_loading_threads_data,
    0.1f
  );

  [texture_loader release];

  struct metil_model* metil_model_player = (
    scene->renderables[
      scene_intro_forest_index_renderable_player
    ].renderable
  );

  zoe_model_player_initialize(
    metil,
    metil_model_player,
    scene->textures[
      textures_scene_intro_forest_player
    ],
    0
  );

  struct metil_object* metil_object_player_body = &(
    metil_model_player->objects[
      zoe_model_player_object_index_body
    ]
  );

  scene->player.size.x = (
    metil_object_player_body->mesh.size.x /
    2.0f
  );

  scene->player.size.y = (
    metil_object_player_body->mesh.size.y
  );

  scene->player.size.z = (
    metil_object_player_body->mesh.size.z /
    2.0f
  );

  struct metil_model* metil_model_player_mirror = (
    scene->renderables[
      scene_intro_forest_index_renderable_player_mirror
    ].renderable
  );

  zoe_model_player_initialize(
    metil,
    metil_model_player_mirror,
    scene->textures[
      textures_scene_intro_forest_player
    ],
    1
  );

  struct metil_object* metil_object_ground = (
    scene->renderables[
      scene_intro_forest_index_renderable_ground
    ].renderable
  );

  zoe_object_ground_initialize(
    metil_object_ground,
    (struct math_c_vector3_float) {
      .x = 2000.0f,
      .y = 500.0f,
      .z = 2000.0f
    },
    scene->textures[
      textures_scene_intro_forest_ground
    ],
    scene->textures[
      textures_scene_intro_forest_tree
    ],
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
    unsigned char index_thread = 0;
    index_thread < metil->system_information.cores_cpu;
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
        1
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
      ) > metil_group_trees->length
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
    unsigned char index_thread = 0;
    index_thread < metil->system_information.cores_cpu;
    ++index_thread
  ) {
    pthread_join(
      zoe_loading_threads_data->loading_threads->threads[
        index_thread +
        1
      ],
      0
    );
  }

  zoe_loading_threads_progress_set(
    zoe_loading_threads_data,
    1.0f
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

  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  rand_initialize(
    &rand_parameters,
    &rand_result,
    &rand_source,
    (
      scene_intro_forest_tree_thread_data->length *
      4
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

    unsigned short int offset_byte = (
      index_renderable * 4
    );

    zoe_object_tree_initialize(
      metil_object_tree,
      (void*) 0,
      (struct math_c_vector2_float) {
        .x = 5.0f,
        .y = 250.0f
      },
      scene->textures[
        textures_scene_intro_forest_tree
      ],
      metil->renderer_interface.metal_device
    );
    
    metil_object_tree->position.x = (
      -(metil_object_tree->mesh.size.x / 2.0f) + (
        (((float)((
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
              2
            ] %
            0xfe +
            0x01
          )
        ) % 10000) / 5000.0f) - 1.0f) * 0.7f *
        (
          metil_object_tree->mesh.size.x - (
            size_bounds->x /
            2.0f
          )
        )
      )
    );

    metil_object_tree->position.z = (
      -(metil_object_tree->mesh.size.z / 2.0f) + (
        (((float)((
          (
            rand_result.bytes[
              offset_byte +
              1
            ]  %
            0xfe +
            0x01
          ) *
          (
            rand_result.bytes[
              offset_byte +
              3
            ] %
            0xfe +
            0x01
          )
        ) % 10000) / 5000.0f) - 1.0f) * 0.7f *
        (
          size_bounds->z - (
            size_bounds->z /
            2.0f
          )
        )
      )
    );

    zoe_loading_threads_progress_increase(
      zoe_loading_threads_data,
      (
        index_renderable /
        metil_group_trees->length *
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
  struct metil_scene* scene
) {
  metil_scene_poll_default(
    metil,
    scene
  );

  struct metil_group* metil_group_trees = (
    scene->renderables[
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
      &scene->player
    );
  }
}

void scene_intro_forest_destroy(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  struct scene_intro_forest_data* scene_intro_forest_data = (
    metil_scene->data
  );

  struct io_proc_data* io_proc_data = (
    scene_intro_forest_data->io_proc_data
  );

  io_proc_data->destroy = 1;

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
    io_proc_data->destroy == 1
  ) {
    metil_audio_io_proc_remove(
      &metil_audio_io_proc_data->metil->audio,
      scene_intro_forest_io_proc
    );

    rand_clean(
      &io_proc_data->rand_result,
      &io_proc_data->rand_source
    );

    free(io_proc_data);

    return 0;
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

      if (
        channel == 0
      ) {
        buffer_out[index_frame] = ((float) ((
          io_proc_data->rand_result.bytes[
            offset_byte % 20500
          ] *
          io_proc_data->rand_result.bytes[
            (offset_byte + 1) % 20500
          ]
        ) % 10000)) / 100000.0f;
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
  
  return 0;
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
    io_proc_data->destroy == 1
  ) {
    metil_audio_io_proc_remove(
      &metil_audio_io_proc_data->metil->audio,
      scene_intro_forest_io_proc
    );

    rand_clean(
      &io_proc_data->rand_result,
      &io_proc_data->rand_source
    );

    free(io_proc_data);

    return 0;
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

      if (
        channel == 0
      ) {
        buffer_out[
          index_buffer_out
        ] = ((float) ((
          io_proc_data->rand_result.bytes[
            offset_byte %
            20500
          ] *
          io_proc_data->rand_result.bytes[
            (offset_byte + 1) %
            20500
          ]
        ) % 10000)) / 100000.0f;
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

  return 0;
}
#endif
