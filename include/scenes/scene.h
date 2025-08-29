#ifndef __scenes_scene_h
#define __scenes_scene_h

#include <object.h>
#include <player.h>

struct scene;

typedef void (*function_scene_poll)(struct scene*);
typedef void (*function_scene_input_poll)(struct scene*);
typedef void (*function_scene_destroy)(struct scene*);

enum scene_type {
  scene_type_menu,
  scene_type_game
};

struct scene {
  id<MTLDevice> metal_kit_device;

  struct player player;
  enum scene_type type;

  struct object** objects;
  unsigned short int length_objects;

  id<MTLTexture>* textures;
  unsigned short int length_textures;

  unsigned char loading;

  function_scene_poll poll;
  function_scene_input_poll input_poll;
  function_scene_destroy destroy;

  void* data;
};

void scene_initialize(
  struct scene*,
  id<MTLDevice>
);

void scene_input_poll(
  struct scene*
);

void scene_poll(
  struct scene*
);

void scene_destroy(
  struct scene*
);

void scene_input_poll_default(
  struct scene*
);

void scene_poll_default(
  struct scene*
);

void scene_destroy_default(
  struct scene*
);

#endif
