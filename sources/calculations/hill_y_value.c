#include <calculations/hill_y_value.h>

#include <math_c_vector.h>

float hill_y_value_get(
  struct math_c_vector2_float* position_percentage
) {
  if (
    position_percentage->x > 0.7f
  ) {
    position_percentage->x = (
      0.7f
    );
  }

  position_percentage->x = (
    position_percentage->x -
    0.2f
  );

  if (
    position_percentage->x < 0.0f
  ) {
    position_percentage->x = (
      0.0f
    );
  }

  position_percentage->y = (
    position_percentage->y -
    0.1f
  );

  if (
    position_percentage->y < 0.0f
  ) {
    position_percentage->y = (
      0.0f
    );
  }

  float position_y = (
    (
      position_percentage->x *
      hill_y_value_elevation_x
    ) + (
      position_percentage->y *
      hill_y_value_elevation_z
    )
  );

  return (
    position_y
  );
}
