#ifndef __input_controller_h
#define __input_controller_h

struct controller_state {
  float trigger_left;
  float trigger_right;

  float input_axis_x_left;
  float input_axis_y_left;

  float input_axis_x_right;
  float input_axis_y_right;

  unsigned char available;
};

void controller_poll(
  struct controller_state*
);

#endif
