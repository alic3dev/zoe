#include <object/zoe_object_auop.h>

#include <mesh/zoe_mesh_auop.h>

#include <metil.h>
#include <metil_object/metil_object.h>

void zoe_object_auop_initialize(
  struct metil* metil,
  struct metil_object* metil_object
) {
  zoe_mesh_auop_initialize(
    &metil_object->mesh
  );

  metil_object_buffers_initialize(
    metil_object,
    metil->renderer_interface.metal_device
  );
}
