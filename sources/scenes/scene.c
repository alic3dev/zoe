#include <scenes/scene.h>

#include <player.h>

void scene_initialize(
  struct scene* scene
) {
  player_initialize(
    &scene->player
  );

  scene->player.position.x = -1.0f;
  scene->player.position.y = -1.0f;
  scene->player.position.z = -10.0f;

  scene->loading = 0;
}

void scene_input_poll(
  struct scene* scene
) {
  player_input_poll(
    &scene->player
  );
}

void scene_poll(
  struct scene* scene
) {
  player_poll(
    &scene->player
  );
}

void scene_destroy(
  struct scene* scene
) {
  player_destroy(
    &scene->player
  );
}
