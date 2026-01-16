#ifndef __data_data_zoe_h
#define __data_data_zoe_h

#include <data/data_player.h>

struct data_zoe {
  struct data_player player;
};

void data_zoe_initialize(
  struct data_zoe*
);

#endif
