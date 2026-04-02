#ifndef __data_data_zoe_h
#define __data_data_zoe_h

#include <data/data_player.h>

struct zoe_data_zoe {
  struct zoe_data_player player;
};

void zoe_data_zoe_initialize(
  struct zoe_data_zoe*
);

#endif
