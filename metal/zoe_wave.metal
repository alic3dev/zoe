#include <math_c_pi.h>
#include <math_c_sine.h>

float4 zoe_wave_get(
  unsigned long int time,
  unsigned long int offset,
  float speed,
  float amount
) {
  float value = (
    (float) (
      time +
      offset
    ) /
    speed
  );

  float4 position_vertex_waved;

  position_vertex_waved.x = (
    math_c_sine(
      value,
      math_c_pi
    ) *
    amount
  );

  position_vertex_waved.y = (
    math_c_cosine(
      value,
      math_c_pi
    ) *
    amount
  );

  position_vertex_waved.z = (
    math_c_sine(
      value,
      math_c_pi
    ) *
    amount
  );

  position_vertex_waved.w = (
    0.0f
  );

  return (
    position_vertex_waved
  );
}
