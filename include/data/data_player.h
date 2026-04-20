#ifndef __zoe_data_data_player_h
#define __zoe_data_data_player_h

#include <inventory/zoe_inventory.h>
#include <items/zoe_item.h>
#include <weapons/zoe_weapon.h>

enum zoe_data_player_action {
  zoe_data_player_action_none             = 0b00000000,
  zoe_data_player_action_select           = 0b00000001,
  zoe_data_player_action_back             = 0b00000010,
  zoe_data_player_action_attack_primary   = 0b10000000,
  zoe_data_player_action_attack_secondary = 0b01000000,
  zoe_data_player_action_item_primary     = 0b00100000,
  zoe_data_player_action_item_secondary   = 0b00010000
};

enum zoe_data_player_attributes {
  zoe_data_player_attributes_none                 = 0b00000000,
  zoe_data_player_attributes_walking              = 0b00000001,
  zoe_data_player_attributes_sneaking             = 0b00000010,
  zoe_data_player_attributes_running              = 0b00000100,
  zoe_data_player_attributes_jumping              = 0b00001000,
  zoe_data_player_attributes_attacking_primary    = 0b00010000,
  zoe_data_player_attributes_attacking_secondary  = 0b00100000,
  zoe_data_player_attributes_item_using_primary   = 0b01000000,
  zoe_data_player_attributes_item_using_secondary = 0b10000000
};

struct zoe_data_player {
  unsigned char actions;
  unsigned char attributes;

  struct zoe_inventory_item* weapon_primary;
  struct zoe_inventory_item* weapon_secondary;

  struct zoe_inventory_item* item_primary;
  struct zoe_inventory_item* item_secondary;

  struct zoe_inventory inventory;
};

void zoe_data_player_initialize(
  struct zoe_data_player*
);

void zoe_data_player_destroy(
  struct zoe_data_player*
);

#endif
