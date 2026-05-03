#ifndef __zoe_zoe_save_files_zoe_save_file_h
#define __zoe_zoe_save_files_zoe_save_file_h

#include <zoe_data/data_player.h>
#include <zoe_save_files/zoe_save_files.h>

#define zoe_save_file_debug_log_save_file_inaccessable "save_files_inaccessable"
#define zoe_save_file_debug_log_save_file_open_failure "failed_to_open_save_file"

unsigned char zoe_save_file_save(
  struct zoe_save_files*,
  struct zoe_data_player*,
  unsigned char
);

unsigned char zoe_save_file_load(
  struct zoe_save_files*,
  struct zoe_data_player*,
  unsigned char
);

#endif
