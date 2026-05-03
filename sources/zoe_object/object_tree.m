#include <zoe_object/object_tree.h>

#include <zoe_mesh/mesh_tree.h>
#include <zoe_pipeline_index.h>

#include <math_c_vector.h>

#include <metil.h>
#include <metil_object/metil_object.h>
#include <metil_object/metil_object_buffer.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <Metal/MTLTexture.h>

void zoe_object_tree_initialize(
  struct metil* metil,
  struct metil_object* metil_object,
  struct metil_mesh* metil_mesh_clone_source,
  struct math_c_vector2_float size,
  id<MTLTexture> texture,
  unsigned int noise,
  struct zoe_pipeline_index* zoe_pipeline_index
) {
  if (
    metil_mesh_clone_source != 0
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
    zoe_pipeline_index->tree
  );

  metil_object_buffers_initialize(
    metil_object,
    metil->renderer_interface.metal_device
  );

  struct metil_renderer_data_object* metil_renderer_data_object_tree = (
    metil_object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  metil_renderer_data_object_tree->noise = (
    noise
  );

  metil_object_texture_add(
    metil_object,
    texture
  );
}
