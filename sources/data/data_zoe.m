#include <data/data_zoe.h>

#include <data/data_player.h>

void zoe_data_zoe_initialize(
  struct zoe_data_zoe* zoe_data_zoe
) {
  zoe_data_player_initialize(
    &zoe_data_zoe->player
  );
}

void data_zoe_destroy(
  struct zoe_data_zoe* zoe_data_zoe
) {
  zoe_data_player_destroy(
    &zoe_data_zoe->player
  );
}
