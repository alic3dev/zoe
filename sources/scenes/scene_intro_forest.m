#include <scenes/scene_intro_forest.h>

#include <audio/io_proc_data.h>
#include <object/object_ground.h>
#include <object/object_player.h>
#include <object/object_tree.h>
#include <scenes/scene_id.h>
#include <zoe_pipeline_index.h>

#include <metil_audio/metil_audio_io_proc.h>
#include <metil_object/metil_object.h>
#include <metil_object/metil_object_buffer.h>
#include <metil_paths/paths.h>
#include <metil_rendering/camera/camera_mode.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/scene.h>

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
  struct metil_scene* scene,
  struct metil_renderer_interface* renderer_interface
) {
  scene->renderer_interface->rendering_properties->camera.mode = (
    metil_camera_mode_third_person
  );

  scene->renderer_interface->rendering_properties->camera.height = (
    metil_camera_height_default *
    4.0f
  );

  metil_scene_initialize_with_renderables(
    scene,
    renderer_interface,
    503
  );

  scene->player.rotation.x = -0.3f;

  scene->data = malloc(
    sizeof(struct scene_intro_forest_data)
  );

  struct scene_intro_forest_data* data_scene = (
    scene->data
  );

  struct io_proc_data* io_proc_data = (
    io_proc_data_create(
      41000
    )
  );

  data_scene->io_proc_data = io_proc_data;

  metil_audio_io_proc_add_with_data(
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
    metil_renderable_initialize_at_index(
      scene->renderables,
      index_renderable,
      metil_renderable_type_object
    );
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
      scene->renderer_interface->metal_device
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
          stringWithUTF8String: metil_paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*)0
    error: (void*)0
  ];

  scene->textures[
    textures_scene_intro_forest_tree
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"zoef.png"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: metil_paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*)0
    error: (void*)0
  ];

  scene->textures[
    textures_scene_intro_forest_player
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"zoef.png"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: metil_paths.directory_textures
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
      0
    ].renderable
  );

  zoe_object_player_initialize(
    object,
    scene->textures[
      textures_scene_intro_forest_player
    ],
    scene->renderer_interface->metal_device,
    0
  );

  object = (
    scene->renderables[
      1
    ].renderable
  );

  zoe_object_player_initialize(
    object,
    scene->textures[
      textures_scene_intro_forest_player
    ],
    scene->renderer_interface->metal_device,
    1
  );

  struct metil_object* metil_object_ground = (
    scene->renderables[
      2
    ].renderable
  );

  zoe_object_ground_initialize(
    metil_object_ground,
    (struct clic3_vector3_float) {
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
    scene->renderer_interface->metal_device
  );

  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  rand_initialize(
    &rand_parameters,
    &rand_result,
    &rand_source, (
      (scene->length_renderables - 3) *
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

  unsigned int offset_byte = 0;

  for (
    unsigned short int index_renderable = 3;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    offset_byte = (
      (index_renderable - 3) * 4
    );

    object = (
      scene->renderables[
        index_renderable
      ].renderable
    );

    zoe_object_tree_initialize(
      object,
      (struct clic3_vector2_float) {
        .x = 5.0f,
        .y = 250.0f
      },
      scene->textures[
        textures_scene_intro_forest_tree
      ],
      scene->renderer_interface->metal_device
    );
    
    object->position.x = (
      -(object->mesh.size.x / 2.0f) + (
        (((float)((
          rand_result.bytes[offset_byte] *
          rand_result.bytes[offset_byte + 2]
        ) % 10000) / 5000.0f) - 1.0f) * 0.7f *
        (object->mesh.size.x - (
          metil_object_ground->mesh.size.x / 2.0f
        ))
      )
    );

    object->position.z = (
      -(object->mesh.size.z / 2.0f) + (
        (((float)((
          rand_result.bytes[offset_byte + 1] *
          rand_result.bytes[offset_byte + 3]
        ) % 10000) / 5000.0f) - 1.0f) * 0.7f *
        (metil_object_ground->mesh.size.z - (
          metil_object_ground->mesh.size.z / 2.0f
        ))
      )
    );
  }

  rand_clean(
    &rand_result,
    &rand_source
  );
}

void scene_intro_forest_poll(
  struct metil_scene* scene
) {
  metil_scene_poll_default(scene);

  for (
    unsigned short int index_renderable = 3;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    struct metil_object* metil_object = (
      scene->renderables[
        index_renderable
      ].renderable
    );

    struct clic3_vector3_float* vertices = metil_object->buffers_vertex[
      metil_object_buffer_default_index_vertices
    ].buffer.contents;
  }
}


void scene_intro_forest_destroy(
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
  struct io_proc_data* io_proc_data = (
    data
  );

  if (
    io_proc_data->destroy == 1
  ) {
    metil_audio_io_proc_remove(
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
  struct io_proc_data* io_proc_data = (
    data
  );

  if (
    io_proc_data->destroy == 1
  ) {
    metil_audio_io_proc_remove(
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
