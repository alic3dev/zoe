#include <scenes/scene_intro_forest.h>

#include <mesh/ground/mesh_ground.h>
#include <mesh/tree/mesh_tree.h>
#include <metal_kit_shader_types.h>
#include <object.h>
#include <paths.h>
#include <scenes/scene.h>

void scene_intro_forest_data_initialize(
  struct scene* scene
) {
  scene->data = (void*)0;
}

void scene_intro_forest_initialize(
  struct scene* scene,
  id<MTLDevice> metal_kit_device
) {
  scene_initialize(
    scene,
    metal_kit_device
  );

  scene->type = scene_type_game;
  scene->id = scene_id_intro_forest;

  scene->length_objects = 501;
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
    textures_scene_intro_forest_ground
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
    textures_scene_intro_forest_tree
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
    textures_scene_intro_forest_ground
  ];

  scene->objects[0]->texture_secondary = scene->textures[
    textures_scene_intro_forest_tree
  ];

  unsigned short int iterator_id = 0;

  metal_kit_data_frame_object* data = scene->objects[0]->data.contents;
  data->id = iterator_id++;
  data->mode_texture = mode_texture_ground;

  for (
    unsigned short int index_object = 1;
    index_object < scene->length_objects;
    ++index_object
  ) {
    scene->objects[index_object] = malloc(
      sizeof(struct object)
    );

    mesh_tree_initialize(
      &(scene->objects[index_object]->mesh),
      1.0f,
      250.0f
    );

    scene->objects[index_object]->position.x = (
      -(scene->objects[index_object]->mesh.size.x / 2.0f) + (
        (((float)(rand() % 10000) / 5000.0f) - 1.0f) * 0.7f *
        (scene->objects[index_object]->mesh.size.x - (scene->objects[0]->mesh.size.x / 2.0f))
      )
    );

    scene->objects[index_object]->position.y = -10.0f;

    scene->objects[index_object]->position.z = (
      -(scene->objects[index_object]->mesh.size.z / 2.0f) + (
        (((float)(rand() % 10000) / 5000.0f) - 1.0f) * 0.7f *
        (scene->objects[0]->mesh.size.z - (scene->objects[0]->mesh.size.z / 2.0f))
      )
    );

    scene->objects[index_object]->vertices = [metal_kit_device
      newBufferWithBytes: scene->objects[index_object]->mesh.vertices
      length: scene->objects[index_object]->mesh.length_vertices * sizeof(struct clic3_vector4_float)
      options: MTLResourceStorageModeShared
    ];

    scene->objects[index_object]->indices = [metal_kit_device
      newBufferWithBytes: scene->objects[index_object]->mesh.indices
      length: (
        sizeof(unsigned int) *
        scene->objects[index_object]->mesh.length_indices
      )
      options: MTLResourceStorageModePrivate
    ];

    scene->objects[index_object]->data = [metal_kit_device
      newBufferWithLength: sizeof(metal_kit_data_frame_object)
      options: MTLResourceStorageModeShared
    ];

    metal_kit_data_frame_object* data = scene->objects[index_object]->data.contents;
    
    data->id = iterator_id++;
    data->mode_texture = mode_texture_default;

    scene->objects[index_object]->texture = scene->textures[
      textures_scene_intro_forest_tree
    ];
  }
}
