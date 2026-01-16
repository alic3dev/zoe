#ifndef __data_data_player_h
#define __data_data_player_h

enum data_player_action {
  data_player_action_none = 0b00000000,
  data_player_action_select = 0b00000001
};

struct data_player {
  unsigned char actions;
};

void data_player_initialize(
  struct data_player*
);

void data_player_destroy(
  struct data_player*
);

#endif
