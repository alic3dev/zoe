#include <scenes/scene_intro_forest.h>

#include <metil_audio/audio.h>
#include <mesh/ground/mesh_ground.h>
#include <mesh/mesh_player.h>
#include <mesh/mesh_player_mirror.h>
#include <mesh/tree/mesh_tree.h>
#include <mode_texture.h>
#include <scenes/scene_id.h>
#include <zoe_pipeline_index.h>

#include <metil_object.h>
#include <metil_scenes/scene.h>

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
  metil_audio_io_proc_add(
    scene_intro_forest_io_proc
  );

  metil_scene_initialize(
    scene,
    metal_device
  );

  scene->type = metil_scene_type_game;
  scene->id = scene_id_intro_forest;

  scene->poll = scene_intro_forest_poll;
  scene->destroy = scene_intro_forest_destroy;

  scene->length_objects = 503;
  scene->objects = realloc(
    scene->objects,
    sizeof(struct metil_object*) *
    scene->length_objects
  );

  for (
    unsigned short int index_object = 0;
    index_object < scene->length_objects;
    ++index_object
  ) {
    scene->objects[index_object] = malloc(
      sizeof(struct metil_object)
    );

    metil_object_initialize(
      scene->objects[index_object]
    );
  }

  scene->length_textures = 3;
  scene->textures = malloc(
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

  mesh_player_initialize(
    &scene->objects[0]->mesh
  );

  scene->objects[0]->index_pipeline_render = zoe_pipeline_index_player;

  metil_object_buffers_initialize(
    scene->objects[0],
    scene->metal_device
  );

  metil_object_texture_add(
    scene->objects[0],
    scene->textures[
      textures_scene_intro_forest_player
    ]
  );

  unsigned short int iterator_id = 0;

  struct metil_renderer_data_object* data = scene->objects[0]->data.contents;
  data->id = iterator_id++;
  data->mode_texture = mode_texture_player;

  mesh_player_mirror_initialize(
    &scene->objects[1]->mesh
  );

  scene->objects[1]->index_pipeline_render = zoe_pipeline_index_player;

  metil_object_buffers_initialize(
    scene->objects[1],
    scene->metal_device
  );

  metil_object_texture_add(
    scene->objects[1],
    scene->textures[
      textures_scene_intro_forest_player
    ]
  );

  data = scene->objects[1]->data.contents;
  data->id = iterator_id++;
  data->mode_texture = mode_texture_player;

  mesh_ground_initialize(
    &scene->objects[2]->mesh,
    2000.0f,
    500.0f,
    2000.0f
  );

  scene->objects[2]->index_pipeline_render = zoe_pipeline_index_ground;

  scene->objects[2]->position.y = -10.0f;

  metil_object_buffers_initialize(
    scene->objects[2],
    scene->metal_device
  );

  metil_object_texture_add(
    scene->objects[2],
    scene->textures[
      textures_scene_intro_forest_ground
    ]
  );

  metil_object_texture_add(
    scene->objects[2],
    scene->textures[
      textures_scene_intro_forest_tree
    ]
  );

  data = scene->objects[2]->data.contents;
  data->id = iterator_id++;
  data->mode_texture = mode_texture_ground;

  for (
    unsigned short int index_object = 3;
    index_object < scene->length_objects;
    ++index_object
  ) {
    mesh_tree_initialize(
      &(scene->objects[index_object]->mesh),
      1.0f,
      250.0f
    );
    
    scene->objects[index_object]->index_pipeline_render = zoe_pipeline_index_tree;

    scene->objects[index_object]->position.x = (
      -(scene->objects[index_object]->mesh.size.x / 2.0f) + (
        (((float)(rand() % 10000) / 5000.0f) - 1.0f) * 0.7f *
        (scene->objects[index_object]->mesh.size.x - (scene->objects[2]->mesh.size.x / 2.0f))
      )
    );

    scene->objects[index_object]->position.y = -10.0f;

    scene->objects[index_object]->position.z = (
      -(scene->objects[index_object]->mesh.size.z / 2.0f) + (
        (((float)(rand() % 10000) / 5000.0f) - 1.0f) * 0.7f *
        (scene->objects[2]->mesh.size.z - (scene->objects[2]->mesh.size.z / 2.0f))
      )
    );

    metil_object_buffers_initialize(
      scene->objects[index_object],
      scene->metal_device
    );

    struct metil_renderer_data_object* data = scene->objects[index_object]->data.contents;
    
    data->id = iterator_id++;
    data->mode_texture = mode_texture_default;

    metil_object_texture_add(
      scene->objects[index_object],
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

  scene->objects[0]->position.x = (
    scene->player.position.x
  );

  scene->objects[0]->position.y = (
    scene->player.position.y
  );

  scene->objects[0]->position.z = (
    scene->player.position.z
  );

  scene->objects[1]->position.x = (
    -scene->player.position.x
  );

  scene->objects[1]->position.y = (
    scene->player.position.y
  );

  scene->objects[1]->position.z = (
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

      if (channel == 0) {
        buffer_out[index_buffer_out] = ((float) (rand() % 10000)) / 100000.0f;
      } else {
        buffer_out[index_buffer_out] = buffer_out[index_buffer_out - channel];
      }
    }
  }

  return 0;
}
