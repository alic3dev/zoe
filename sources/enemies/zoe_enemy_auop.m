#include <enemies/zoe_enemy_auop.h>

#include <enemies/zoe_enemy.h>

#include <metil_mesh/metil_mesh_box.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable.h>

void zoe_enemy_auop_initialize(
  struct metil* metil,
  struct zoe_enemy* zoe_enemy_auop,
  struct metil_renderable* zoe_enemy_auop_renderable
) {
  zoe_enemy_initialize(
    metil,
    zoe_enemy_auop,
    zoe_enemy_auop_renderable
  );

  zoe_enemy_auop->health_maximum = (
    zoe_enemy_auop_default_health_maximum
  );
  
  zoe_enemy_auop->health = (
    zoe_enemy_auop_default_health
  );

  metil_renderable_initialize(
    zoe_enemy_auop->renderable,
    metil_renderable_type_object
  );

  struct metil_object* zoe_enemy_object = (
    zoe_enemy_auop->renderable->renderable
  );

  metil_mesh_box_initialize(
    &zoe_enemy_object->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0x04
      ),
      .y = (
        0x04
      ),
      .z = (
        0x04
      )
    }
  );

  metil_object_buffers_initialize(
    zoe_enemy_object,
    metil->renderer_interface.metal_device
  );
}
