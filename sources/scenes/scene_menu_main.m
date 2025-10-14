#include <scenes/scene_menu_main.h>

#include <menus/menu_main.h>
#include <mesh/ground/mesh_ground.h>
#include <mesh/mesh_text.h>
#include <metil_rendering/camera/camera.h>
#include <mesh/tree/mesh_tree.h>
#include <mode_texture.h>
#include <scenes/scene_id.h>
#include <zoe_pipeline_index.h>

#include <metil.h>

#include <CoreAudio/CoreAudio.h>

#include <math.h>

const unsigned long int scene_menu_main_time_scene_transition = 333;

void scene_menu_main_initialize(
  struct metil_scene* scene,
  id<MTLDevice> metal_device
) {
  metil_audio_io_proc_add(
    scene_menu_main_io_proc
  );

  metil_scene_initialize(
    scene,
    metal_device
  );

  scene->poll = scene_menu_main_poll;
  scene->poll_input = scene_menu_main_poll_input;
  scene->destroy = scene_menu_main_destroy;

  scene->data = malloc(
    sizeof(struct scene_menu_main_data)
  );

  struct scene_menu_main_data* data = (struct scene_menu_main_data*) scene->data;

  data->time_started = 0;

  menu_main_initialize(
    &data->menu
  );

  scene->type = metil_scene_type_menu;
  scene->id = scene_id_menu_main;

  scene->length_objects = 5;
  scene->objects = realloc(
    scene->objects,
    sizeof(struct metil_object*) *
    scene->length_objects
  );

  scene->objects[0] = malloc(
    sizeof(struct metil_object)
  );

  scene->length_textures = 5;
  scene->textures = malloc(
    sizeof(id<MTLTexture>) *
    scene->length_textures
  );

  MTKTextureLoader* texture_loader = [[MTKTextureLoader alloc] initWithDevice: metal_device];

  scene->textures[
    textures_scene_menu_main_ground
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
    textures_scene_menu_main_tree
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

  metil_object_initialize(
    scene->objects[0]
  );

  mesh_ground_initialize(
    &scene->objects[0]->mesh,
    666.0f,
    6666.6f,
    666.0f
  );

  metil_object_buffers_initialize(
    scene->objects[0],
    scene->metal_device
  );

  scene->objects[0]->index_pipeline_render = (
    zoe_pipeline_index_ground
  );

  scene->objects[0]->texture = scene->textures[
    textures_scene_menu_main_ground
  ];

  scene->objects[0]->texture_secondary = scene->textures[
    textures_scene_menu_main_tree
  ];

  unsigned short int iterator_id = 0;

  struct metil_renderer_data_object* data_object = scene->objects[0]->data.contents;
  data_object->id = iterator_id++;
  data_object->mode_texture = mode_texture_ground;
  data_object->noise = 666;

  scene->objects[1] = malloc(
    sizeof(struct metil_object)
  );

  metil_object_initialize(
    scene->objects[1]
  );

  mesh_tree_initialize(
    &(scene->objects[1]->mesh),
    1.0f,
    66.6f
  );

  scene->objects[1]->index_pipeline_render = (
    zoe_pipeline_index_tree
  );

  metil_object_buffers_initialize(
    scene->objects[1],
    scene->metal_device
  );

  data_object = scene->objects[1]->data.contents;
  
  data_object->id = iterator_id++;
  data_object->mode_texture = mode_texture_default;
  data_object->noise = 666;

  scene->objects[1]->texture = scene->textures[
    textures_scene_menu_main_tree
  ];

  scene->objects[2] = malloc(
    sizeof(struct metil_object)
  );

  metil_object_initialize(
    scene->objects[2]
  );

  scene->objects[2]->index_pipeline_render = (
    zoe_pipeline_index_text
  );

  scene->textures[
    textures_scene_menu_main_title
  ] = metil_text_mesh_with_texture_initialize(
    metal_device,
    &scene->objects[2]->mesh,
    "zoe",
    metil_font_reference_monospace,
    0.001f
  );

  metil_object_buffers_initialize(
    scene->objects[2],
    scene->metal_device
  );

  scene->objects[2]->position.y = 0.5f - (scene->objects[2]->mesh.size.y / 4.0f);

  data_object = scene->objects[2]->data.contents;
  
  data_object->id = iterator_id++;
  data_object->mode_texture = mode_texture_text;
  data_object->noise = 10000;

  scene->objects[2]->texture = scene->textures[
    textures_scene_menu_main_title
  ];

  scene->objects[3] = malloc(
    sizeof(struct metil_object)
  );

  metil_object_initialize(
    scene->objects[3]
  );

  scene->objects[3]->index_pipeline_render = (
    zoe_pipeline_index_text
  );

  scene->textures[
    textures_scene_menu_main_menu_enter
  ] = metil_text_mesh_with_texture_initialize(
    metal_device,
    &scene->objects[3]->mesh,
    "enter",
    metil_font_reference_monospace,
    0.001f
  );

  metil_object_buffers_initialize(
    scene->objects[3],
    scene->metal_device
  );

  scene->objects[3]->position.y = -scene->objects[3]->mesh.size.y * 6.0;

  data_object = scene->objects[3]->data.contents;
  
  data_object->id = iterator_id++;
  data_object->mode_texture = mode_texture_text;

  scene->objects[3]->texture = scene->textures[
    textures_scene_menu_main_menu_enter
  ];

  scene->objects[4] = malloc(
    sizeof(struct metil_object)
  );

  metil_object_initialize(
    scene->objects[4]
  );

  scene->objects[4]->index_pipeline_render = (
    zoe_pipeline_index_text
  );

  scene->textures[
    textures_scene_menu_main_menu_exit
  ] = metil_text_mesh_with_texture_initialize(
    metal_device,
    &scene->objects[4]->mesh,
    "exit",
    metil_font_reference_monospace,
    0.001f
  );

  metil_object_buffers_initialize(
    scene->objects[4],
    scene->metal_device
  );

  scene->objects[4]->position.y = -scene->objects[4]->mesh.size.y * 10.0f;

  data_object = scene->objects[4]->data.contents;
  
  data_object->id = iterator_id++;
  data_object->mode_texture = mode_texture_text;

  scene->objects[4]->texture = scene->textures[
    textures_scene_menu_main_menu_exit
  ];

  scene->player.position.y = (
    -metil_camera_height_default + 3.0f
  );

  scene->player.position.z = (
    -100.0f
  );

  scene->player.rotation.x = 0.3f;
}

void scene_menu_main_poll(
  struct metil_scene* scene
) {
  scene->player.rotation.x = fmin((
      scene->player.rotation.x +
      (0.00001f * sin(
        ((0.6f - (scene->player.rotation.x - 0.3f)) / 0.6f) *
        M_PI_2
      )) *
      scene->time_delta
    ),
    0.9f
  );

  struct scene_menu_main_data* data = (struct scene_menu_main_data*) scene->data;

  struct metil_menu* menu = &data->menu;

  switch (menu->index_current) {
    case 0: {
      struct metil_renderer_data_object* data_object = scene->objects[3]->data.contents;
      data_object->noise = 1600 + (rand() % 666);
      data_object = scene->objects[4]->data.contents;
      data_object->noise = 10000;
      break;
    }
    case 1: {
      struct metil_renderer_data_object* data_object = scene->objects[4]->data.contents;
      data_object->noise = 1600 + (rand() % 666);
      data_object = scene->objects[3]->data.contents;
      data_object->noise = 10000;
      break;
    }
  }

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
      scene->rendering_properties.brightness = 0.0f;
      scene->rendering_properties.brightness_text = 0.0f;

      metil_scene_controller_scene_change(
        scene_id_intro_forest
      );
    } else {
      float brightness = (
        (float) (scene_menu_main_time_scene_transition - time_delta) / (float) scene_menu_main_time_scene_transition
      );

      scene->rendering_properties.brightness = brightness;
      scene->rendering_properties.brightness_text = brightness;
    }
  } else if (
    menu->index_selected != -1 &&
    menu->handled == 0
  ) {
    menu->handled = 1;

    switch (menu->index_selected) {
      case 0:
        metil_debug_log("STARTING\n");

        data->time_started = scene->time;
        break;
      case 1:
        metil_debug_log("EXITING\n");
        
        [[NSApplication sharedApplication] terminate: 0];
        break;
    }
  }
}

void scene_menu_main_poll_input(
  struct metil_scene* scene
) {
  struct metil_menu* menu = &(((struct scene_menu_main_data*) scene->data)->menu);

  metil_menu_poll_input(
    menu
  );
}

void scene_menu_main_destroy(
  struct metil_scene* scene
) {
  metil_audio_io_proc_remove(
    scene_menu_main_io_proc
  );

  metil_menu_destroy(
    &((struct scene_menu_main_data*) scene->data)->menu
  );

  metil_scene_destroy_default(scene);
}

OSStatus scene_menu_main_io_proc(
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

      if (index_buffer == 0) {
        buffer_out[index_buffer_out] = ((float) (rand() % 10000)) / 10000.0f;
      } else {
        buffer_out[index_buffer_out] = buffer_out[index_buffer_out - channel];
      }
    }
  }

  return 0;
}
