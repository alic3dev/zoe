#include <object/object_ground.h>

#include <mesh/mesh_ground.h>
#include <zoe_pipeline_index.h>

#include <clic3_vector.h>

#include <metil_object/metil_object.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_object_ground_initialize(
  struct metil_object* metil_object,
  struct clic3_vector3_float size,
  id<MTLTexture> texture_one,
  id<MTLTexture> texture_two,
  id<MTLDevice> metal_device
) {
  mesh_ground_initialize(
    &metil_object->mesh,
    &size
  );

  metil_object_buffers_initialize(
    metil_object,
    metal_device
  );

  metil_object->index_pipeline_render = (
    zoe_pipeline_index_ground
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
