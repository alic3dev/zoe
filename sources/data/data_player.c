#include <data/data_player.h>

void data_player_initialize(
  struct data_player* data_player
) {
  data_player->actions = (
    data_player_action_none
  );
}

void data_player_destroy(
  struct data_player* data_player
) {}
