#include <object/object_tree.h>

#include <mesh/mesh_tree.h>
#include <zoe_pipeline_index.h>

#include <math_c_vector.h>

#include <metil_object/metil_object.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_object_tree_initialize(
  struct metil_object* metil_object,
  struct metil_mesh* metil_mesh_clone_source,
  struct math_c_vector2_float size,
  id<MTLTexture> texture,
  id<MTLDevice> metal_device
) {
  if (
    metil_mesh_clone_source != (void*) 0
  ) {
    metil_mesh_clone(
      metil_mesh_clone_source,
      &metil_object->mesh
    );
  } else {
    mesh_tree_initialize(
      &metil_object->mesh,
      &size
    );
  }

  metil_object->index_pipeline_render = (
    zoe_pipeline_index_tree
  );

  metil_object_buffers_initialize(
    metil_object,
    metal_device
  );

  metil_object_texture_add(
    metil_object,
    texture
  );
}
