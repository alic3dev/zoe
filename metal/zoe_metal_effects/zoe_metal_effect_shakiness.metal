#include <zoe_metal/effects/zoe_metal_effect_shakiness.h>

float4 zoe_metal_effect_shakiness_get(
  unsigned long int time,
  unsigned long int offset,
  unsigned long int speed,
  float amount
) {
  unsigned long int value = (
    (
      time /
      speed +
      offset
    ) %
    0x64
  );

  if (
    (
      value %
      0x02
    ) ==
    0x00
  ) {
    amount = -(
      amount
    );
  }

  float4 position_vertex_shaken;

  position_vertex_shaken.x = (
    (
      (float)
      value /
      100.0f
    ) *
    amount
  );

  value = (
    (
      value +
      0x0d
    ) %
    0x64
  );

  position_vertex_shaken.y = (
    (
      (float)
      value /
      100.0f
    ) *
    amount
  );

  value = (
    (
      value +
      0x1f
    ) %
    0x64
  );

  position_vertex_shaken.z = (
    (
      (float)
      value /
      100.0f
    ) *
    amount
  );

  position_vertex_shaken.w = (
    0x00
  );

  return (
    position_vertex_shaken
  );
}
