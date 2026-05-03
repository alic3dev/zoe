#ifndef __zoe_data_zoe_data_enemy_h
#define __zoe_data_zoe_data_enemy_h

#define zoe_data_enemy_buffer_index_default_object (\
  0x03\
)

#define zoe_data_enemy_buffer_index_default_model (\
  0x05\
)
struct zoe_data_enemy {
  unsigned short int health;
  unsigned short int health_maximum;

  unsigned long int time_damaged;
};

#ifndef __METAL_VERSION__
void zoe_data_enemy_initialize(
  struct zoe_data_enemy*
);
#endif

#endif
