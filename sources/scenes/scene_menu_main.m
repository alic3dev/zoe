#include <scenes/scene_menu_main.h>

#include <input/keycodes.h>
#include <input/map.h>
#include <menus/menu.h>
#include <menus/menu_intro.h>
#include <mesh/ground/mesh_ground.h>
#include <mesh/tree/mesh_tree.h>
#include <metal_kit_shader_types.h>
#include <object.h>
#include <paths.h>
#include <scenes/scene.h>
#include <scenes/scene_controller.h>

void scene_menu_main_initialize(
  struct scene* scene,
  id<MTLDevice> metal_kit_device
) {
  scene_initialize(
    scene,
    metal_kit_device
  );

  scene->poll = scene_menu_main_poll;
  scene->poll_input = scene_menu_main_poll_input;
  scene->destroy = scene_menu_main_destroy;

  scene->data = malloc(
    sizeof(struct menu)
  );

  struct menu* menu = scene->data;

  menu_intro_initialize(
    menu
  );

  menu_print(menu);

  scene->type = scene_type_menu;
  scene->id = scene_id_menu_main;

  scene->length_objects = 2;
  scene->objects = realloc(
    scene->objects,
    sizeof(struct object*) *
    scene->length_objects
  );

  scene->objects[0] = malloc(
    sizeof(struct object)
  );

  scene->length_textures = 2;
  scene->textures = malloc(
    sizeof(id<MTLTexture>) *
    scene->length_textures
  );

  MTKTextureLoader* texture_loader = [[MTKTextureLoader alloc] initWithDevice: metal_kit_device];

  scene->textures[
    textures_scene_menu_main_ground
  ] = [texture_loader
    newTextureWithContentsOfURL: [NSURL
      fileURLWithPath:@"0028.png"
      isDirectory: 0
      relativeToURL: [NSURL
        fileURLWithPath:[NSString
          stringWithUTF8String: paths.directory_textures
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
          stringWithUTF8String: paths.directory_textures
        ]
        isDirectory: 1
      ]
    ]
    options: (void*)0
    error: (void*)0
  ];

  [texture_loader release];

  mesh_ground_initialize(
    &scene->objects[0]->mesh,
    2000.0f,
    500.0f,
    2000.0f
  );

  scene->objects[0]->position.y = -10.0f;

  scene->objects[0]->vertices = [metal_kit_device
    newBufferWithBytes: scene->objects[0]->mesh.vertices
    length: scene->objects[0]->mesh.length_vertices * sizeof(struct clic3_vector4_float)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[0]->indices = [metal_kit_device
    newBufferWithBytes: scene->objects[0]->mesh.indices
    length: scene->objects[0]->mesh.length_indices * sizeof(unsigned int)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[0]->data = [metal_kit_device
    newBufferWithLength: sizeof(metal_kit_data_frame_object)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[0]->texture = scene->textures[
    textures_scene_menu_main_ground
  ];

  scene->objects[0]->texture_secondary = scene->textures[
    textures_scene_menu_main_tree
  ];

  unsigned short int iterator_id = 0;

  metal_kit_data_frame_object* data = scene->objects[0]->data.contents;
  data->id = iterator_id++;
  data->mode_texture = mode_texture_ground;

  scene->objects[1] = malloc(
    sizeof(struct object)
  );

  mesh_tree_initialize(
    &(scene->objects[1]->mesh),
    1.0f,
    66.6f
  );

  scene->objects[1]->position.x = (
    -(scene->objects[1]->mesh.size.x)
  );

  scene->objects[1]->position.y = -10.0f;

  scene->objects[1]->vertices = [metal_kit_device
    newBufferWithBytes: scene->objects[1]->mesh.vertices
    length: scene->objects[1]->mesh.length_vertices * sizeof(struct clic3_vector4_float)
    options: MTLResourceStorageModeShared
  ];

  scene->objects[1]->indices = [metal_kit_device
    newBufferWithBytes: scene->objects[1]->mesh.indices
    length: (
      sizeof(unsigned int) *
      scene->objects[1]->mesh.length_indices
    )
    options: MTLResourceStorageModePrivate
  ];

  scene->objects[1]->data = [metal_kit_device
    newBufferWithLength: sizeof(metal_kit_data_frame_object)
    options: MTLResourceStorageModeShared
  ];

  data = scene->objects[1]->data.contents;
  
  data->id = iterator_id++;
  data->mode_texture = mode_texture_default;

  scene->objects[1]->texture = scene->textures[
    textures_scene_menu_main_tree
  ];

  scene->player.position.y = (
    6.66f
  );

  scene->player.position.z = (
    -50.0f
  );

  scene->player.rotation.x = -0.666f;
}

void scene_menu_main_poll(
  struct scene* scene
) {
  struct menu* menu = (struct menu*) scene->data;

  menu_print(menu);

  if (
    menu->index_selected != -1 &&
    menu->handled == 0
  ) {
    menu->handled = 1;

    switch (menu->index_selected) {
      case 0:
        printf("STARTING\n");
        scene_controller_scene_change(
          scene_id_intro_forest
        );
        break;
      case 1:
        printf("EXITING\n");
        [[NSApplication sharedApplication] terminate: 0];
        break;
    }
  }
}

void scene_menu_main_poll_input(
  struct scene* scene
) {
  struct menu* menu = (struct menu*) scene->data;

  menu_poll_input(
    menu
  );
}

void scene_menu_main_destroy(
  struct scene* scene
) {
  menu_destroy(
    (struct menu*) scene->data
  );

  scene_destroy_default(scene);
}

void menu_print(
  struct menu* menu
) {
  printf("\e[H\e[2J\e[3J");

  switch(
    menu->index_current
  ) {
    case 0:
      printf(
        "> start\n"
        "  exit\n"
      );
      break;
    case 1:
      printf(
        "  start\n"
        "> exit\n"
      );
      break;
    default:
      printf(
        "  start\n"
        "  exit\n"
      );
      break;
  }
}
