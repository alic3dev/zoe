#include <scenes/scene_intro_hill.h>

#include <audio/io_proc_data.h>
#include <calculations/hill_y_value.h>
#include <mesh/mesh_hill.h>
#include <object/object_hill.h>
#include <object/object_player.h>
#include <object/object_tree.h>
#include <scenes/scene_id.h>
#include <zoe_pipeline_index.h>

#include <metil.h>
#include <metil_audio/metil_audio_io_proc.h>
#include <metil_audio/metil_audio_io_proc_data.h>
#include <metil_object/metil_object.h>
#include <metil_object/metil_object_buffer.h>
#include <metil_paths/metil_paths.h>
#include <metil_rendering/metil_camera/metil_camera_mode.h>
#include <metil_scenes/metil_scene.h>

#include <math_c_absolute.h>

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

void scene_intro_hill_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
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
    5
  );

  scene->player.rotation.x = -0.3f;

  scene->data = malloc(
    sizeof(struct scene_intro_hill_data)
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
    metil_renderable_initialize_at_index(
      scene->renderables,
      index_renderable,
      metil_renderable_type_object
    );
  }

  scene->length_textures = (
    scene_intro_hill_length_textures
  );

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
    scene_intro_hill_textures_hill
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
    options: (void*)0
    error: (void*)0
  ];

  scene->textures[
    scene_intro_hill_textures_tree
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
    options: (void*)0
    error: (void*)0
  ];

  scene->textures[
    scene_intro_hill_textures_player
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
    options: (void*)0
    error: (void*)0
  ];

  [texture_loader release];

  struct metil_object* object = (
    scene->renderables[
      scene_intro_hill_index_renderable_player
    ].renderable
  );

  zoe_object_player_initialize(
    object,
    scene->textures[
      scene_intro_hill_textures_player
    ],
    metil->renderer_interface.metal_device,
    0
  );

  object = (
    scene->renderables[
      scene_intro_hill_index_renderable_player_mirror
    ].renderable
  );

  zoe_object_player_initialize(
    object,
    scene->textures[
      scene_intro_hill_textures_player_mirror
    ],
    metil->renderer_interface.metal_device,
    1
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
    metil->renderer_interface.metal_device
  );

  struct metil_object* metil_object_tree_zoe = (
    scene->renderables[
      scene_intro_hill_index_renderable_tree_zoe
    ].renderable
  );

  zoe_object_tree_initialize(
    metil_object_tree_zoe,
    (void*) 0,
    (struct clic3_vector2_float) {
      .x = 33.3f,
      .y = 333.5f
    },
    scene->textures[
      scene_intro_hill_textures_tree
    ],
    metil->renderer_interface.metal_device
  );

  metil_object_tree_zoe->position.y = 100.0f;
  metil_object_tree_zoe->position.z = 1666.1f;

  struct metil_object* metil_object_tree_zoe_mirror = (
    scene->renderables[
      scene_intro_hill_index_renderable_tree_zoe_mirror
    ].renderable
  );

  zoe_object_tree_initialize(
    metil_object_tree_zoe_mirror,
    &metil_object_tree_zoe->mesh,
    (struct clic3_vector2_float) {
      .x = 33.3f,
      .y = 333.5f
    },
    scene->textures[
      scene_intro_hill_textures_tree
    ],
    metil->renderer_interface.metal_device
  );

  metil_object_tree_zoe_mirror->position.y = 100.0f;
  metil_object_tree_zoe_mirror->position.z = -1666.1f;
}

void scene_intro_hill_poll(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_poll_default(
    metil,
    scene
  );

  struct clic3_vector2_float position_percentage = {
    .x = (
      math_c_absolute_float(
        scene->player.position.x / (
          length_vertices_hill_x
        )
      ) / 2.0f
    ),
    .y = (
      math_c_absolute_float(
        scene->player.position.z / (
          length_vertices_hill_y
        )
      ) / 2.0f
    )
  };

  scene->player.position.y = (
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

    free(
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

    free(
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
