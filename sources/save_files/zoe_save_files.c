#include <save_files/zoe_save_files.h>

#include <clic3_char_arrays.h>
#include <clic3_memory.h>

#include <metil_debug/metil_debug_log.h>

#include <stdio.h>
#include <stdlib.h>
#include <sys/syslimits.h>
#include <sys/stat.h>

unsigned char zoe_save_files_load(
  struct zoe_save_files* zoe_save_files
) {
  char* path_directory_home = (
    getenv(
      "HOME"
    )
  );

  char* path_directory_save_files_unresolved = (
    clic3_char_arrays_concatenate(
      path_directory_home,
      zoe_save_files_path_directory_save_files
    )
  );
  
  char* path_directory_save_files = (
    realpath(
      path_directory_save_files_unresolved,
      0x00
    )
  );

  if (
    path_directory_save_files ==
    0x00
  ) {
    char* path_directory_save_files_parent_unresolved = (
      clic3_char_arrays_concatenate(
        path_directory_home,
        zoe_save_files_path_directory_save_files_parent
      )
    );

    char* path_directory_save_files_parent = (
      realpath(
        path_directory_save_files_parent_unresolved,
        0x00
      )
    );

    int status_make_directory = (
      0x00
    );

    if (
      path_directory_save_files_parent ==
      0x00
    ) {
      status_make_directory = (
        mkdir(
          path_directory_save_files_parent_unresolved,
          0777
        )
      );

      if (
        status_make_directory !=
        0x00
      ) {
        metil_debug_log(
          metil_debug_log_level_error,
          "failed_to_create_saves_files_directories\n"
        );
      }
    } else {
      clic3_memory_free_raw(
        path_directory_save_files_parent
      );
    }

    clic3_memory_free_raw(
      path_directory_save_files_parent_unresolved
    );

    if (
      status_make_directory ==
      0x00
    ) {
      status_make_directory = (
        mkdir(
          path_directory_save_files_unresolved,
          0777
        )
      );
    }

    if (
      status_make_directory !=
      0x00
    ) {
      metil_debug_log(
        metil_debug_log_level_error,
        "failed_to_create_saves_files_directories\n"
      );

      clic3_memory_free_raw(
        path_directory_save_files_unresolved
      );

      return (
        0x01
      );
    }

    path_directory_save_files = (
      realpath(
        path_directory_save_files_unresolved,
        0x00
      )
    );
  }

  clic3_memory_free_raw(
    path_directory_save_files_unresolved
  );

  struct stat stat_save_directory;

  for (
    unsigned char index_save_file = (
      0x00
    );
    (
      index_save_file <
      zoe_save_files_length_save_files
    );
    ++index_save_file
  ) {
    char path_name_save_file[
      0x0d
    ] = {
      '/',
      's',
      'a',
      'v',
      'e',
      '_',
      'f',
      'i',
      'l',
      'e',
      '_',
      (
        '0' +
        index_save_file
      ),
      '\0'
    };

    char* path_save_file = (
      clic3_char_arrays_concatenate(
        path_directory_save_files,
        path_name_save_file
      )
    );

    clic3_memory_free_raw(
      path_save_file
    );
  }

  clic3_memory_free_raw(
    path_directory_save_files
  );

  return (
    0x00
  );
}
