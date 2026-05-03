#include <zoe_object/attack_effects/zoe_object_attack_effect_slice.h>

#include <zoe_attack_effects/zoe_attack_effect.h>
#include <zoe_data/data_zoe.h>
#include <zoe_mesh/attack_effects/zoe_mesh_attack_effect_slice.h>

#include <metil.h>
#include <metil_object/metil_object.h>

void zoe_object_attack_effect_slice_initialize(
  struct metil* metil,
  struct metil_object* zoe_object_attack_effect_slice,
  unsigned int time
) {
  zoe_mesh_attack_effect_slice_initialize(
    &zoe_object_attack_effect_slice->mesh,
    time
  );

  metil_object_buffers_initialize(
    zoe_object_attack_effect_slice,
    metil->renderer_interface.metal_device
  );

  zoe_attack_effect_buffer_data_add(
    metil,
    zoe_object_attack_effect_slice,
    time,
    0x01e8
  );

  struct zoe_data_zoe* zoe_data_zoe = (
    metil->data
  );

  zoe_object_attack_effect_slice->index_pipeline_render = (
    zoe_data_zoe->pipeline_index.effect_attack_slice
  );
}
