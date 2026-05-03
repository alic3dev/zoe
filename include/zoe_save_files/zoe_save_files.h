#ifndef __zoe_save_files_zoe_save_files_h
#define __zoe_save_files_zoe_save_files_h

#define zoe_save_files_path_directory_save_files_parent "/.saves/"
#define zoe_save_files_path_directory_save_files "/.saves/zoe/"

#define zoe_save_files_length_save_files 0x05

struct zoe_save_files {
  unsigned char selected_slot;

  unsigned long int saved_at[
    zoe_save_files_length_save_files
  ];

  unsigned char used[
    zoe_save_files_length_save_files
  ];

  char* path_directory_save_files;
  char* path_save_file[
    zoe_save_files_length_save_files
  ];
};

unsigned char zoe_save_files_initialize(
  struct zoe_save_files*
);

unsigned char zoe_save_files_load(
  struct zoe_save_files*
);

char* zoe_save_files_save_file_path_resolve(
  char*,
  unsigned char
);

void zoe_save_files_destroy(
  struct zoe_save_files*
);

#endif
