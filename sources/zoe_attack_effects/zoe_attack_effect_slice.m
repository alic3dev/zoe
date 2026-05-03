#include <zoe_attack_effects/zoe_attack_effect_slice.h>

#include <zoe_attack_effects/zoe_attack_effect.h>
#include <zoe_object/attack_effects/zoe_object_attack_effect_slice.h>

#include <math_c_modulus.h>
#include <math_c_vector.h>

#include <metil.h>
#include <metil_object/metil_object.h>

void zoe_attack_effect_slice_initialize(
  struct metil* metil,
  struct zoe_attack_effect* zoe_attack_effect_slice,
  struct math_c_vector3_float* position,
  struct math_c_vector3_float* rotation
) {
  struct metil_object* zoe_object_attack_effect_slice = (
    zoe_attack_effect_slice->renderable->renderable
  );

  zoe_object_attack_effect_slice_initialize(
    metil,
    zoe_object_attack_effect_slice,
    zoe_attack_effect_slice->time_started
  );

  zoe_object_attack_effect_slice->position.x = (
    position->x
  );

  zoe_object_attack_effect_slice->position.y = (
    position->y +
    0x06
  );

  zoe_object_attack_effect_slice->position.z = (
    position->z
  );

  zoe_object_attack_effect_slice->rotation.y = -(
    rotation->y
  );

  zoe_object_attack_effect_slice->rotation.z = (
    math_c_modulus_mirror_float(
      (
        position->x +
        position->y +
        position->z +
        rotation->x +
        rotation->y +
        rotation->z
      ),
      2.0f
     ) -
    1.0f
  );
}
