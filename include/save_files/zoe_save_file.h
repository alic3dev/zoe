#ifndef __zoe_save_files_zoe_save_file_h
#define __zoe_save_files_zoe_save_file_h

#include <data/data_player.h>

unsigned char zoe_save_file_save(
  struct zoe_data_player*,
  unsigned char
);

unsigned char zoe_save_file_load(
  struct zoe_data_player*,
  unsigned char
);

#endif

