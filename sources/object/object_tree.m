#include <object/object_tree.h>

#include <mesh/mesh_tree.h>
#include <zoe_pipeline_index.h>

#include <clic3_vector.h>

#include <metil_object/metil_object.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_object_tree_initialize(
  struct metil_object* metil_object,
  struct clic3_vector2_float size,
  id<MTLTexture> texture,
  id<MTLDevice> metal_device
) {
  mesh_tree_initialize(
    &metil_object->mesh,
    &size
  );

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
