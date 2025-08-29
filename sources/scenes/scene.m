#include <scenes/scene.h>

#include <object.h>
#include <player.h>

void scene_initialize(
  struct scene* scene,
  id<MTLDevice> metal_kit_device
) {
  scene->metal_kit_device = metal_kit_device;

  player_initialize(
    &scene->player
  );

  scene->length_objects = 0;
  scene->objects = malloc(
    sizeof(struct object*) *
    scene->length_objects
  );

  scene->type = scene_type_game;

  scene->player.position.x = 0.0f;
  scene->player.position.y = 0.0f;
  scene->player.position.z = 0.0f;

  scene->poll = scene_poll_default;
  scene->input_poll = scene_input_poll_default;
  scene->destroy = scene_destroy_default;

  scene->loading = 0;
}

void scene_input_poll(
  struct scene* scene
) {
  scene->input_poll(
    scene
  );
}

void scene_poll(
  struct scene* scene
) {
  scene->poll(
    scene
  );
}

void scene_destroy(
  struct scene* scene
) {
  scene->destroy(
    scene
  );
}

void scene_input_poll_default(
  struct scene* scene
) {
  player_input_poll(
    &scene->player
  );
}

void scene_poll_default(
  struct scene* scene
) {
  player_poll(
    &scene->player
  );
}

void scene_destroy_default(
  struct scene* scene
) {
  for (
    unsigned short int index_object = 0;
    index_object < scene->length_objects;
    ++index_object
  ) {
    object_destroy(
      scene->objects[index_object]
    );

    free(scene->objects[index_object]);
  }

  free(scene->objects);

  for (
    unsigned short int index_texture = 0;
    index_texture < scene->length_textures;
    ++index_texture
  ) {
    [scene->textures[index_texture] release];
  }
  free(scene->textures);

  player_destroy(
    &scene->player
  );

  if (
    scene->data != (void*)0
  ) {
    free(scene->data);
  }
}
