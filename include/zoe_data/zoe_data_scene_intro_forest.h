#ifndef __zoe_zoe_data_zoe_data_scene_intro_forest_h
#define __zoe_zoe_data_zoe_data_scene_intro_forest_h

#include <zoe_audio/io_proc_data.h>
#include <zoe_enemies/zoe_enemy_controller.h>

struct zoe_data_scene_intro_forest {
  struct io_proc_data* _Nonnull io_proc_data;

  struct zoe_enemy_controller enemy_controller;

  unsigned char index_text;
};

#endif
