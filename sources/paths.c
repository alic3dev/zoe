#include <paths.h>

#include <clic3.h>

#include <stdlib.h>

struct paths paths;

void paths_initialize(
  char* directory_root
) {
  paths.length_directory_root = 0;
  paths.length_directory_resources = 0;
  paths.length_directory_textures = 0;

  paths_directory_root_set(
    directory_root
  );

  paths_directory_resources_set();
  paths_directory_textures_set();
}

void paths_directory_root_set(
  char* directory_root
) {
  unsigned int index_slash = 0;

  while (
    directory_root[paths.length_directory_root] != '\0'
  ) {
    if (
      directory_root[paths.length_directory_root] == '/'
    ) {
      index_slash = paths.length_directory_root;
    }

    paths.length_directory_root = (
      paths.length_directory_root + 1
    );
  }

  if (index_slash < 2) {
    paths.length_directory_root = 3;

    paths.directory_root = malloc(
      sizeof(char) * paths.length_directory_root
    );

    paths.directory_root[0] = '.';
    paths.directory_root[1] = '/';
    paths.directory_root[2] = '\0';
  } else {
    paths.length_directory_root = index_slash + 2;

    paths.directory_root = malloc(
      sizeof(char) * paths.length_directory_root
    );

    clic3_bytes_copy(
      paths.directory_root,
      directory_root,
      paths.length_directory_root - 1
    );

    paths.directory_root[
      paths.length_directory_root - 1
    ] = '\0';
  }
}

void paths_directory_resources_set() {
  paths.length_directory_resources = (
    paths.length_directory_root + 13
  );

  paths.directory_resources = clic3_char_arrays_concatenate(
    paths.directory_root,
    "../Resources/"
  );
}

void paths_directory_textures_set() {
  paths.length_directory_resources = (
    paths.length_directory_root + 9
  );

  paths.directory_textures = clic3_char_arrays_concatenate(
    paths.directory_resources,
    "textures/"
  );
}

void paths_destroy() {
  free(paths.directory_root);
  free(paths.directory_resources);
  free(paths.directory_textures);
}
