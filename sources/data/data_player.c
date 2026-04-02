#include <data/data_player.h>

void zoe_data_player_initialize(
  struct zoe_data_player* zoe_data_player
) {
  zoe_data_player->actions = (
    zoe_data_player_action_none
  );

  zoe_data_player->attributes = (
    zoe_data_player_attributes_none
  );
}

void zoe_data_player_destroy(
  struct zoe_data_player* zoe_data_player
) {
}
