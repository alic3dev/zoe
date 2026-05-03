#include <zoe_attack_effects/zoe_attack_effect.h>

#include <zoe_data/zoe_data_attack_effect.h>

#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable.h>

void zoe_attack_effect_initialize(
  struct zoe_attack_effect* zoe_attack_effect,
  struct metil_renderable* zoe_attack_effect_renderable,
  unsigned long int time_started
) {
  zoe_attack_effect->renderable = (
    zoe_attack_effect_renderable
  );

  zoe_attack_effect->time_started = (
    time_started
  );

  zoe_attack_effect->length = (
    0x03e8
  );
}

void zoe_attack_effect_buffer_data_add(
  struct metil* metil,
  struct metil_object* zoe_object_attack_effect,
  unsigned int time,
  unsigned int length) {
  metil_object_buffers_add(
    zoe_object_attack_effect,
    metil->renderer_interface.metal_device,
    metil_object_buffer_type_vertex
  );

  zoe_object_attack_effect->buffers_vertex[
    zoe_data_attack_effect_buffer_index -
    0x01
  ].buffer = [
    metil->renderer_interface.metal_device
    newBufferWithLength: (
      sizeof(
        struct zoe_data_attack_effect
      )
    )
    options: (
      MTLResourceStorageModeShared
    )
  ];

  struct zoe_data_attack_effect* zoe_data_attack_effect = (
    zoe_object_attack_effect->buffers_vertex[
      zoe_data_attack_effect_buffer_index -
      0x01
    ].buffer.contents
  );

  zoe_data_attack_effect->time_started = (
    time
  );

  zoe_data_attack_effect->length = (
    length
  );
}

