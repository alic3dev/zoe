#include <scenes/scene_intro_forest.h>

#include <metil_audio/audio.h>
#include <mesh/ground/mesh_ground.h>
#include <mesh/mesh_player.h>
#include <mesh/mesh_player_mirror.h>
#include <mesh/tree/mesh_tree.h>
#include <scenes/scene_id.h>
#include <zoe_pipeline_index.h>

#include <metil_object.h>
#include <metil_scenes/scene.h>

#include <rand_functions.h>
#include <rand_initialize.h>
#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>
#include <rand_source_type.h>

#include <stdlib.h>

void scene_intro_forest_data_initialize(
  struct metil_scene* scene
) {
  scene->data = (void*)0;
}

void scene_intro_forest_initialize(
  struct metil_scene* scene,
  id<MTLDevice> metal_device
) {
  metil_scene_initialize_with_renderables(
    scene,
    metal_device,
    503
  );

  scene->data = malloc(
    sizeof(struct scene_intro_forest_io_proc_data)
  );

  struct scene_intro_forest_io_proc_data* io_proc_data = (
    (struct scene_intro_forest_io_proc_data*) scene->data
  );

  rand_initialize(
    &io_proc_data->rand_parameters_io_proc,
    &io_proc_data->rand_result_io_proc,
    &io_proc_data->rand_source_io_proc, 
    41000,
    rand_mode_bytes,
    rand_source_type_divisive
  );

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

  MTKTextureLoader* texture_loader = [[MTKTextureLoader alloc] initWithDevice: metal_device];

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

  mesh_player_initialize(
    &object->mesh
  );

  object->index_pipeline_render = zoe_pipeline_index_player;

  metil_object_buffers_initialize(
    object,
    scene->metal_device
  );

  metil_object_texture_add(
    object,
    scene->textures[
      textures_scene_intro_forest_player
    ]
  );

  unsigned short int iterator_id = 0;

  struct metil_renderer_data_object* data = object->data.contents;
  data->id = iterator_id++;

  object = (
    scene->renderables[
      1
    ].renderable
  );

  mesh_player_mirror_initialize(
    &object->mesh
  );

  object->index_pipeline_render = zoe_pipeline_index_player;

  metil_object_buffers_initialize(
    object,
    scene->metal_device
  );

  metil_object_texture_add(
    object,
    scene->textures[
      textures_scene_intro_forest_player
    ]
  );

  data = object->data.contents;
  data->id = iterator_id++;

  struct metil_object* object_ground = (
    scene->renderables[
      2
    ].renderable
  );

  mesh_ground_initialize(
    &object_ground->mesh,
    2000.0f,
    500.0f,
    2000.0f
  );

  object_ground->index_pipeline_render = zoe_pipeline_index_ground;

  metil_object_buffers_initialize(
    object_ground,
    scene->metal_device
  );

  metil_object_texture_add(
    object_ground,
    scene->textures[
      textures_scene_intro_forest_ground
    ]
  );

  metil_object_texture_add(
    object_ground,
    scene->textures[
      textures_scene_intro_forest_tree
    ]
  );

  data = object_ground->data.contents;
  data->id = iterator_id++;

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

    mesh_tree_initialize(
      &(object->mesh),
      1.0f,
      250.0f
    );
    
    object->index_pipeline_render = zoe_pipeline_index_tree;

    object->position.x = (
      -(object->mesh.size.x / 2.0f) + (
        (((float)((
          rand_result.bytes[offset_byte] *
          rand_result.bytes[offset_byte + 2]
        ) % 10000) / 5000.0f) - 1.0f) * 0.7f *
        (object->mesh.size.x - (
          object_ground->mesh.size.x / 2.0f
        ))
      )
    );

    object->position.z = (
      -(object->mesh.size.z / 2.0f) + (
        (((float)((
          rand_result.bytes[offset_byte + 1] *
          rand_result.bytes[offset_byte + 3]
        ) % 10000) / 5000.0f) - 1.0f) * 0.7f *
        (object_ground->mesh.size.z - (
          object_ground->mesh.size.z / 2.0f
        ))
      )
    );

    metil_object_buffers_initialize(
      object,
      scene->metal_device
    );

    struct metil_renderer_data_object* data = object->data.contents;
    
    data->id = iterator_id++;

    metil_object_texture_add(
      object,
      scene->textures[
        textures_scene_intro_forest_tree
      ]
    );
  }
}

void scene_intro_forest_poll(
  struct metil_scene* scene
) {
  metil_scene_poll_default(scene);

  struct metil_object* object_player = (
    scene->renderables[
      0
    ].renderable
  );

  struct metil_object* object_player_mirror = (
    scene->renderables[
      1
    ].renderable
  );

  object_player->position.x = (
    scene->player.position.x
  );

  object_player->position.y = (
    scene->player.position.y
  );

  object_player->position.z = (
    scene->player.position.z
  );

  object_player_mirror->position.x = (
    -scene->player.position.x
  );

  object_player_mirror->position.y = (
    scene->player.position.y
  );

  object_player_mirror->position.z = (
    -scene->player.position.z
  );
}


void scene_intro_forest_destroy(
  struct metil_scene* scene
) {
  metil_audio_io_proc_remove(
    scene_intro_forest_io_proc
  );

  metil_scene_destroy_default(scene);
}

OSStatus scene_intro_forest_io_proc(
  AudioObjectID id_audio_object,
  const AudioTimeStamp* time_stamp_audio,
  const AudioBufferList* list_buffer_audio_in,
  const AudioTimeStamp* time_stamp_audio_in,
  AudioBufferList* list_buffer_audio_out,
  const AudioTimeStamp* time_stamp_audio_out,
  void* data
) {
  struct scene_intro_forest_io_proc_data* io_proc_data = (
    (struct scene_intro_forest_io_proc_data*) data
  );

  rand_get(
    &io_proc_data->rand_source_io_proc,
    &io_proc_data->rand_result_io_proc,
    &io_proc_data->rand_parameters_io_proc
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
      unsigned int offset_byte = index_buffer_out * 2;

      if (channel == 0) {
        buffer_out[index_buffer_out] = ((float) ((
          io_proc_data->rand_result_io_proc.bytes[
            offset_byte % 20500
          ] *
          io_proc_data->rand_result_io_proc.bytes[
            (offset_byte + 1) % 20500
          ]
        ) % 10000)) / 100000.0f;
      } else {
        buffer_out[index_buffer_out] = buffer_out[index_buffer_out - channel];
      }
    }
  }

  return 0;
}
