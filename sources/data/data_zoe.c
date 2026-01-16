#include <data/data_zoe.h>

#include <data/data_player.h>

void data_zoe_initialize(
  struct data_zoe* data_zoe
) {
  data_player_initialize(
    &data_zoe->player
  );
}

void data_zoe_destroy(
  struct data_zoe* data_zoe
) {
  data_player_destroy(
    &data_zoe->player
  );
}
