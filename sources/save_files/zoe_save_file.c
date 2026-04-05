#include <save_files/zoe_save_file.h>

#include <data/data_player.h>
#include <save_files/zoe_save_files.h>

#include <metil_debug/metil_debug_log.h>


#include <stdio.h>
unsigned char zoe_save_file_save(
  struct zoe_save_files* zoe_save_files,
  struct zoe_data_player* zoe_data_player,
  unsigned char index_save_file
) {
  if (
    (
      index_save_file >=
      zoe_save_files_length_save_files
    ) ||
    (
      zoe_save_files->path_save_file[
        index_save_file
      ] ==
      0x00
    )
  ) {
    metil_debug_log(
      metil_debug_log_level_error,
      zoe_save_file_debug_log_save_file_inaccessable
    );

    return (
      0x01
    );
  }

  FILE* file_save_file = (    fopen(
      zoe_save_files->path_save_file[
        index_save_file
      ],
      "wb"
    )
  );

  if (
    file_save_file ==
    0x00
  ) {
    metil_debug_log(
      metil_debug_log_level_error,
      zoe_save_file_debug_log_save_file_open_failure
    );

    return (
      0x01
    );
  }

  fclose(
    file_save_file
  );
  return (
    0x00
  );
}

unsigned char zoe_save_file_load(
  struct zoe_save_files* zoe_save_files,
  struct zoe_data_player* zoe_data_player,
  unsigned char index_save_file
) {
  if (
    (
      index_save_file >=
      zoe_save_files_length_save_files
    ) ||
    (
      zoe_save_files->path_save_file[
        index_save_file
      ] ==
      0x00
    )
  ) {
    metil_debug_log(
      metil_debug_log_level_error,
      zoe_save_file_debug_log_save_file_inaccessable
    );

    return (
      0x01
    );
  }

  FILE* file_save_file = (
    fopen(
      zoe_save_files->path_save_file[
        index_save_file
      ],
      "rb"
    )
  );

  if (
    file_save_file ==
    0x00
  ) {
    metil_debug_log(
      metil_debug_log_level_error,
      zoe_save_file_debug_log_save_file_open_failure
    );

    return (
      0x01
    );
  }

  fclose(
    file_save_file
  );

  return (
    0x00
  );
}
