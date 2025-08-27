#include <input/controller.h>

#include <GameController/GameController.h>

void controller_poll(
  struct controller_state* controller_state
) {
  // TODO: GCDualSenseGamepad: Add DualSense specific functionality

  GCController* controller = [GCController current];
  GCExtendedGamepad* profile_controller = (
    controller != (void*)0
    ? (GCDualSenseGamepad*) [controller extendedGamepad]
    : (void*)0
  );

  if (profile_controller != (void*)0) {
    GCControllerButtonInput* trigger_left = [profile_controller leftTrigger];
    GCControllerButtonInput* trigger_right = [profile_controller rightTrigger];
    
    GCControllerDirectionPad* thumbstick_right = [profile_controller rightThumbstick];
    GCControllerAxisInput* input_axis_y_right = [thumbstick_right yAxis];
    GCControllerAxisInput* input_axis_x_right = [thumbstick_right xAxis];

    GCControllerDirectionPad* thumbstick_left = [profile_controller leftThumbstick];
    GCControllerAxisInput* input_axis_y_left = [thumbstick_left yAxis];
    GCControllerAxisInput* input_axis_x_left = [thumbstick_left xAxis];

    controller_state->trigger_left = trigger_left.value;
    controller_state->trigger_right = trigger_right.value;

    controller_state->input_axis_x_left = input_axis_x_left.value;
    controller_state->input_axis_y_left = input_axis_y_left.value;

    controller_state->input_axis_x_right = input_axis_x_right.value;
    controller_state->input_axis_y_right = input_axis_y_right.value;

    controller_state->thumbstick_button_left = [profile_controller leftThumbstickButton].value;
    controller_state->thumbstick_button_right = [profile_controller rightThumbstickButton].value;

    controller_state->available = 1;
  } else {
    controller_state->trigger_left = 0.0f;
    controller_state->trigger_right = 0.0f;

    controller_state->input_axis_x_left = 0.0f;
    controller_state->input_axis_y_left = 0.0f;

    controller_state->input_axis_x_right = 0.0f;
    controller_state->input_axis_y_right = 0.0f;

    controller_state->thumbstick_button_left = 0.0f;
    controller_state->thumbstick_button_right = 0.0f;

    controller_state->available = 0;
  }
}
