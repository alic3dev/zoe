#ifndef __zoe_enemies_zoe_enemy_h
#define __zoe_enemies_zoe_enemy_h

#include <metil_rendering/metil_renderable.h>

struct zoe_enemy {
  unsigned short int health;
  unsigned short int health_maximum;

  struct metil_renerable* renderable;
};

#endif
