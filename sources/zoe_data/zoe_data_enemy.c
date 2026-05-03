#include <zoe_data/zoe_data_enemy.h>

void zoe_data_enemy_initialize(
  struct zoe_data_enemy* zoe_data_enemy
) {
  zoe_data_enemy->health = (
    0x00
  );

  zoe_data_enemy->health_maximum = (
    0x00
  );

  zoe_data_enemy->time_damaged = (
    0x00
  );
}
