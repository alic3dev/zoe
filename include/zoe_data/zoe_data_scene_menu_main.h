#ifndef __zoe_zoe_data_zoe_data_scene_menu_main_h
#define __zoe_zoe_data_zoe_data_scene_menu_main_h

#include <zoe_audio/io_proc_data.h>

#include <metil_menus/metil_menu.h>

#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>

#define scene_menu_main_time_scene_transition 0x0d05

struct scene_menu_main_data {
  struct metil_menu menu;

  unsigned long int time_started;

  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  struct io_proc_data* io_proc_data;
};

#endif
