#include <save_files/zoe_save_files.h>

#include <clic3_char_arrays.h>
#include <clic3_memory.h>

#include <metil_debug/metil_debug_log.h>

#include <stdio.h>
#include <stdlib.h>
#include <sys/syslimits.h>
#include <sys/stat.h>  

unsigned char zoe_save_files_initialize(
  struct zoe_save_files* zoe_save_files
) {
  zoe_save_files->path_directory_save_files = (
    0x00
  );

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
    zoe_save_files->saved_at[
      index_save_file
    ] = (
      0x00
    );

    zoe_save_files->used[
      index_save_file
    ] = (
      0x00
    );

    zoe_save_files->path_save_file[
      index_save_file
    ] = (
      0x00
    );
  }

  char* path_directory_home = (
    getenv(
      "HOME"
    )
  );

  if (
    path_directory_home ==
    0x00
  ) {
    return (
      0x01
    );
  }

  char* path_directory_save_files_unresolved = (
    clic3_char_arrays_concatenate(
      path_directory_home,
      zoe_save_files_path_directory_save_files
    )
  );
  
  zoe_save_files->path_directory_save_files = (
    realpath(
      path_directory_save_files_unresolved,
      0x00
    )
  );

  if (
    zoe_save_files->path_directory_save_files ==
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
        "failed_to_create_saves_files_directories"
      );

      clic3_memory_free_raw(
        path_directory_save_files_unresolved
      );

      return (
        0x01
      );
    }

    zoe_save_files->path_directory_save_files = (
      realpath(
        path_directory_save_files_unresolved,
        0x00
      )
    );
  }

  clic3_memory_free_raw(
    path_directory_save_files_unresolved
  );

  return (
    0x00
  );
}


unsigned char zoe_save_files_load(
  struct zoe_save_files* zoe_save_files
) {  if (
    zoe_save_files->path_directory_save_files ==
    0x00
  ) {
    return (
      0x01
    );
  }

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
    clic3_memory_free(
      zoe_save_files->path_save_file[
        index_save_file
      ]
    );    

    zoe_save_files->path_save_file[
      index_save_file
    ] = (
      zoe_save_files_save_file_path_resolve(
        zoe_save_files->path_directory_save_files,
        index_save_file
      )
    );

    if (
      zoe_save_files->path_save_file[
        index_save_file
      ] ==
      0x00
    ) {
      continue;
    }

    struct stat stat_save_file;

    int status_stat = (
      stat(
        zoe_save_files->path_save_file[
          index_save_file
        ],
        &stat_save_file
      )
    );

    if (
      status_stat ==
      0x00
    ) {
      zoe_save_files->saved_at[
        index_save_file
      ] = (
        stat_save_file.st_mtimespec.tv_sec
      );

      zoe_save_files->used[
        index_save_file
      ] = (
        0x01
      );
    } else {
      zoe_save_files->saved_at[
        index_save_file
      ] = (
        0x00
      );

      zoe_save_files->used[
        index_save_file
      ] = (
        0x00
      );
    }
  }

  return (
    0x00
  );
}

char* zoe_save_files_save_file_path_resolve(
  char* path_directory_save_files,
  unsigned char index_save_file
) {
  if (
    path_directory_save_files ==
    0x00
  ) {
    return (
      0x00
    );
  }

  char path_save_file_name[
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

  static char* path_save_file;

  path_save_file = (
    clic3_char_arrays_concatenate(
      path_directory_save_files,
      path_save_file_name
    )
  );

  return (
    path_save_file
  );
}

void zoe_save_files_destroy(
  struct zoe_save_files* zoe_save_files
) {
  clic3_memory_free(
    zoe_save_files->path_directory_save_files
  );

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
    clic3_memory_free(
      zoe_save_files->path_save_file[
        index_save_file
      ]
    );
  }
}
