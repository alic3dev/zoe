#include <zoe_attack_effects/zoe_attack_effects_controller.h>

#include <zoe_attack_effects/zoe_attack_effect.h>
#include <zoe_data/zoe_data_attack_effect.h>

#include <clic3_memory.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_object/metil_object.h>
#include <metil_scenes/metil_scene.h>

void zoe_attack_effects_controller_initialize(
  struct zoe_attack_effects_controller* zoe_attack_effects_controller,
  struct metil_group* zoe_attack_effects_group,
  unsigned long int* time
) {
  zoe_attack_effects_controller->group = (
    zoe_attack_effects_group
  );

  zoe_attack_effects_controller->attack_effects = (
    clic3_memory_allocate_raw(
      0x00
    )
  );

  zoe_attack_effects_controller->time = (
    time
  );
}

struct zoe_attack_effect* zoe_attack_effects_controller_add(
  struct zoe_attack_effects_controller* zoe_attack_effects_controller
) {
  clic3_memory_reallocate_raw(
    &zoe_attack_effects_controller->attack_effects,
    (
      sizeof(
        void*
      ) *
      (
        zoe_attack_effects_controller->group->length +
        0x01
      )
    )
  );

  zoe_attack_effects_controller->attack_effects[
    zoe_attack_effects_controller->group->length
  ] = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_attack_effect
      )
    )
  );

  struct zoe_attack_effect* zoe_attack_effect = (
    zoe_attack_effects_controller->attack_effects[
      zoe_attack_effects_controller->group->length
    ]
  );

  metil_group_add_length_initialize(
    zoe_attack_effects_controller->group,
    0x01,
    metil_renderable_type_object
  );

  zoe_attack_effect_initialize(
    zoe_attack_effect,
    zoe_attack_effects_controller->group->renderables[
      zoe_attack_effects_controller->group->length -
      0x01
    ],
    *zoe_attack_effects_controller->time
  );

  return (
    zoe_attack_effect
  );
}

void zoe_attack_effects_controller_poll(
  struct metil* metil,
  struct metil_scene* metil_scene,
  struct zoe_attack_effects_controller* zoe_attack_effects_controller
) {
  for (
    unsigned int index_attack_effect = (
      0x00
    );
    (
      index_attack_effect <
      zoe_attack_effects_controller->group->length
    );
  ) {
    struct metil_object* zoe_object_attack_effect = (
      zoe_attack_effects_controller->group->renderables[
        index_attack_effect
      ]->renderable
    );

    struct zoe_data_attack_effect* zoe_data_attack_effect = (
      zoe_object_attack_effect->buffers_vertex[
        zoe_data_attack_effect_buffer_index -
        0x01
      ].buffer.contents
    );

    if (
      (
        (*zoe_attack_effects_controller->time) -
        zoe_data_attack_effect->time_started
      ) >
      zoe_data_attack_effect->length
    ) {
      metil_group_destroy_renderable_at_index(
        metil,
        zoe_attack_effects_controller->group,
        index_attack_effect
      );

      clic3_memory_free_raw(
        zoe_attack_effects_controller->attack_effects[
          index_attack_effect
        ]
      );

      for (
        unsigned int index_attack_effect_shift = (
          index_attack_effect
        );
        (
          index_attack_effect_shift <
          zoe_attack_effects_controller->group->length
        );
        ++index_attack_effect_shift
      ) {
        zoe_attack_effects_controller->attack_effects[
          index_attack_effect_shift
        ] = (
          zoe_attack_effects_controller->attack_effects[
            index_attack_effect_shift +
            0x01
          ]
        );
      }
    } else {
      index_attack_effect = (
        index_attack_effect +
        0x01
      );
    } 
  }  
}

void zoe_attack_effects_controller_destroy(
  struct zoe_attack_effects_controller* zoe_attack_effects_controller
) {
  for (
    unsigned int index_attack_effect = (
      0x00
    );
    (
      index_attack_effect <
      zoe_attack_effects_controller->group->length
    );
    ++index_attack_effect
  ) {
    clic3_memory_free_raw(
      zoe_attack_effects_controller->attack_effects[
        index_attack_effect
      ]
    );
  }

  clic3_memory_free_raw(
    zoe_attack_effects_controller->attack_effects
  );
}
