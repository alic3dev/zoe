#include <mesh/mesh.h>

#include <clic3.h>

#include <stdlib.h>

void mesh_initialize(
  struct mesh* mesh
) {
  mesh->length_indices = 0;
  mesh->length_vertices = 0;

  mesh->indices = malloc(
    sizeof(unsigned int) *
    mesh->length_indices
  );

  mesh->vertices = malloc(
    sizeof(struct clic3_vector4_float) *
    mesh->length_vertices
  );
}

void mesh_destroy(
  struct mesh* mesh
) {
  free(mesh->indices);
  free(mesh->vertices);
}
