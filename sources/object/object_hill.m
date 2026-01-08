#include <object/object_hill.h>

#include <mesh/mesh_hill.h>
#include <zoe_pipeline_index.h>

#include <math_c_vector.h>

#include <metil_object/metil_object.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_object_hill_initialize(
  struct metil_object* metil_object,
  id<MTLTexture> texture_one,
  id<MTLTexture> texture_two,
  id<MTLDevice> metal_device
) {
  mesh_hill_initialize(
    &metil_object->mesh
  );

  metil_object_buffers_initialize(
    metil_object,
    metal_device
  );

  metil_object->index_pipeline_render = (
    zoe_pipeline_index_hill
  );

  metil_object_texture_add(
    metil_object,
    texture_one
  );

  metil_object_texture_add(
    metil_object,
    texture_two
  );
}
