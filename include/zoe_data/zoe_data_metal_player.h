#ifndef __zoe_zoe_data_zoe_data_metal_player_h
#define __zoe_zoe_data_zoe_data_metal_player_h

struct zoe_data_metal_player {
  unsigned char actions;
  unsigned char attributes;

  unsigned short int health;
  unsigned short int health_maximum;

  unsigned long int time_damaged;
};

#ifndef __METAL_VERSION__
void zoe_data_metal_player_initialize(
  struct zoe_data_metal_player*
);
#endif

#endif
