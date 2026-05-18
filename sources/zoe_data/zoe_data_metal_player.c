#include <zoe_data/zoe_data_metal_player.h>

void zoe_data_metal_player_initialize(
  struct zoe_data_metal_player* zoe_data_metal_player
) {
  zoe_data_metal_player->actions = (
    0x00
  );

  zoe_data_metal_player->attributes = (
    0x00
  );

  zoe_data_metal_player->health = (
    0x01
  );

  zoe_data_metal_player->health_maximum = (
    0x01
  );

  zoe_data_metal_player->time_damaged = (
    0x00
  );
}
