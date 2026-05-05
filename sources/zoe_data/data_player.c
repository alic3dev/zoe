#include <zoe_data/data_player.h>

#include <zoe_inventory/zoe_inventory.h>

void zoe_data_player_initialize(
  struct zoe_data_player* zoe_data_player
) {
  zoe_data_player->actions = (
    zoe_data_player_action_none
  );

  zoe_data_player->attributes = (
    zoe_data_player_attributes_none
  );

  zoe_data_player->health_maximum = (
    zoe_data_player_default_health_maximum
  );

  zoe_data_player->health  = (
    zoe_data_player->health_maximum
  );

  zoe_data_player->time_damaged = (
    0x00
  );

  zoe_data_player->item_primary = (
    0x00
  );

  zoe_data_player->item_secondary = (
    0x00
  );

  zoe_data_player->weapon_primary = (
    0x00
  );

  zoe_data_player->weapon_secondary = (
    0x00
  );

  zoe_inventory_initialize(
    &zoe_data_player->inventory
  );
}

void zoe_data_player_destroy(
  struct zoe_data_player* zoe_data_player
) {
  zoe_inventory_destroy(
    &zoe_data_player->inventory
  );
}
