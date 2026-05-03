#include <zoe_metal/effects/zoe_metal_effect_damaged.h>

void zoe_metal_effect_damaged_apply_colours(
  thread float4* colour,
  unsigned int time_current,
  unsigned int time_damaged
) {
  if (
    time_damaged ==
    0x00
  ) {
    return;
  }

  unsigned long int time_elapsed = (
    time_current -
    time_damaged
  );

  if (
    time_elapsed >
    0x64 *
    0x0a
  ) {
    return;
  }

  float percentage = (
    (float)
    time_elapsed /
    (
      0x64 *
      0x0a
    )
  );

  colour->x = (
    colour->x
  );

  colour->y = (
    colour->y *
    percentage
  );

  colour->z = (
    colour->z
  );
}
