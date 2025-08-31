#ifndef __mesh_h
#define __mesh_h

#include <clic3_vector.h>

struct mesh {
  unsigned int* indices;
  struct clic3_vector4_float* vertices;
  struct clic3_vector3_float size;

  unsigned int length_indices;
  unsigned int length_vertices;

  void* data;
};

void mesh_initialize(
  struct mesh*
);

void mesh_destroy(
  struct mesh*
);

#endif
