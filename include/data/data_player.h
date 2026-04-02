#ifndef __zoe_data_data_player_h
#define __zoe_data_data_player_h

enum zoe_data_player_action {
  zoe_data_player_action_none   = 0b00000000,
  zoe_data_player_action_select = 0b00000001
};

enum zoe_data_player_attributes {
  zoe_data_player_attributes_none    = 0b00000000,
  zoe_data_player_attributes_walking = 0b00000001,
  zoe_data_player_attributes_running = 0b00000010,
  zoe_data_player_attributes_jumping = 0b00000100
};

struct zoe_data_player {
  unsigned char actions;
  unsigned char attributes;
};

void zoe_data_player_initialize(
  struct zoe_data_player*
);

void zoe_data_player_destroy(
  struct zoe_data_player*
);

#endif
