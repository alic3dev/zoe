#include <input/input_movement.h>

#include <data/data_player.h>

#include <math_c_vector.h>

#include <metil.h>
#include <metil_input/metil_input.h>
#include <metil_input/metil_keycodes.h>
#include <metil_player/metil_player.h>
#include <metil_player/metil_player_defaults.h>

void zoe_input_movement(
  struct metil* metil,
  struct metil_player* metil_player,
  unsigned long int time,
  unsigned long int time_delta
) {
  struct data_player* data_player = (
    metil_player->data
  );

  float speed_original = (
    metil_player->speed_movement
  );

  float speed_delta = (
    (float) time_delta /
    1000.0f
  );

  metil_player->speed_movement = (
    metil_player->speed_movement *
    speed_delta
  );

  if (
    metil->input.keydown_map[
      metil_keycode_e
    ] == 1 ||
    metil->input.keydown_map[
      metil_keycode_o
    ] == 1 ||
    metil->input.controller_state.triangle != 0.0f
  ) {
    data_player->actions = (
      data_player->actions |
      data_player_action_select
    );
  }

  if (
    metil->input.controller_state.available == 1 &&
    metil->input.controller_state.l2 >= 0.1f &&
    metil->input.controller_state.l3 == 0.0f
  ) {
    metil_player->speed_movement = (
      metil_player->speed_movement *
      (metil->input.controller_state.l2 + 1.0f)
    );
  } else if (
    metil->input.controller_state.available == 1 &&
    metil->input.controller_state.l2 < 0.1f &&
    metil->input.controller_state.l3 >= 0.1f
  ) {
    metil_player->speed_movement = (
      metil_player->speed_movement / (
        metil->input.controller_state.l3 + 1.0f
      )
    );
  } else if (
    (
      metil->input.keydown_map[
        metil_keycode_option_right
      ] == 1 ||
      metil->input.keydown_map[
        metil_keycode_control
      ] == 1
    )  && (
      metil->input.keydown_map[
        metil_keycode_shift_left
      ] == 0 &&
      metil->input.keydown_map[
        metil_keycode_shift_right
      ] == 0
    )
  ) {
    metil_player->speed_movement = (
      metil_player->speed_movement / 2.0f
    );
  } else if (
    (
      metil->input.keydown_map[
        metil_keycode_option_right
      ] == 0 &&
      metil->input.keydown_map[
        metil_keycode_control
      ] == 0
    ) && (
      metil->input.keydown_map[
        metil_keycode_shift_left
      ] == 1 ||
      metil->input.keydown_map[
        metil_keycode_shift_right
      ] == 1
    )
  ) {
    metil_player->speed_movement = (
      metil_player->speed_movement * 2.0f
    );
  }

  struct math_c_vector3_float movement = {
    .x = 0.0f,
    .y = 0.0f,
    .z = 0.0f
  };

  struct math_c_vector2_float ratio_movement = {
    .x = 0.0f,
    .y = 0.0f
  };

  struct math_c_vector2_float ratio_movement_strafe = {
    .x = 0.0f,
    .y = 0.0f
  };

  if (
    metil->input.cursor.locked == 1
  ) {
    metil_player->rotation.y = (
      metil_player->rotation.y - (
        metil->input.cursor.delta.x / 50.0f *
        metil_player->speed_rotation
      )
    );

    metil_player->rotation.x = (
      metil_player->rotation.x - (
        metil->input.cursor.delta.y / 50.0f *
        metil_player->speed_rotation
      )
    );

    metil->input.cursor.delta.x = 0;
    metil->input.cursor.delta.y = 0;
  }

  if (
    metil->input.controller_state.available == 1
  ) {
    if (
      metil->input.controller_state.right_stick.x >= metil_player->deadzone_stick ||
      metil->input.controller_state.right_stick.x <= -metil_player->deadzone_stick
    ) {
      metil_player->rotation.y = (
        metil_player->rotation.y - (
          metil->input.controller_state.right_stick.x *
          metil_player->speed_rotation
        )
      );
    }

    if (
      metil->input.controller_state.right_stick.y >= metil_player->deadzone_stick ||
      metil->input.controller_state.right_stick.y <= -metil_player->deadzone_stick
    ) {
      metil_player->rotation.x = (
        metil_player->rotation.x + (
          metil->input.controller_state.right_stick.y *
          metil_player->speed_rotation
        )
      );
    }
  }

  if (
    metil_player->rotation.x > M_PI / 2.0f
  ) {
    metil_player->rotation.x = M_PI / 2.0f;
  } else if (
    metil_player->rotation.x < -M_PI / 2.0f
  ) {
    metil_player->rotation.x = -M_PI / 2.0f;
  }

  metil_player->rotation.y = fmod(
    metil_player->rotation.y, (
      M_PI * 2.0f
    )
  );

  float ratio_axis = -(
    metil_player->rotation.y / (
      M_PI *
      2.0f
    )
  );

  if (
    ratio_axis >= 0.0f &&
    ratio_axis <= 0.25f
  ) {
    ratio_movement.y = (0.25f - ratio_axis) / 0.25f;
    ratio_movement.x = (ratio_axis / 0.25f);

    ratio_movement_strafe.y = -(ratio_axis / 0.25f);
    ratio_movement_strafe.x = (0.25f - ratio_axis) / 0.25f;
  } else if (
    ratio_axis >= 0.25f &&
    ratio_axis <= 0.5f
  ) {
    ratio_axis = ratio_axis - 0.25f;

    ratio_movement.y = -(ratio_axis / 0.25f);
    ratio_movement.x = (0.25f - ratio_axis) / 0.25f;

    ratio_movement_strafe.y = -(0.25f - ratio_axis) / 0.25f;
    ratio_movement_strafe.x = -(ratio_axis / 0.25f);
  } else if (
    ratio_axis >= 0.5f &&
    ratio_axis <= 0.75f
  ) {
    ratio_axis = ratio_axis - 0.5f;

    ratio_movement.y = -(0.25f - ratio_axis) / 0.25f;
    ratio_movement.x = -(ratio_axis / 0.25f);

    ratio_movement_strafe.y = (ratio_axis / 0.25f);
    ratio_movement_strafe.x = -(0.25f - ratio_axis) / 0.25f;
  } else if (
    ratio_axis > 0.75f
  ) {
    ratio_axis = ratio_axis - 0.75f;

    ratio_movement.y = (ratio_axis / 0.25f);
    ratio_movement.x = -(0.25f - ratio_axis) / 0.25f;

    ratio_movement_strafe.y = (0.25f - ratio_axis) / 0.25f;
    ratio_movement_strafe.x = (ratio_axis / 0.25f);
  } else if (
    ratio_axis >= -0.25f
  ) {
    ratio_movement.y = (-0.25f - ratio_axis) / -0.25f;
    ratio_movement.x = (ratio_axis / 0.25f);

    ratio_movement_strafe.y = -(ratio_axis / 0.25f);
    ratio_movement_strafe.x = (-0.25f - ratio_axis) / -0.25f;
  } else if (
    ratio_axis <= -0.25f &&
    ratio_axis >= -0.5f
  ) {
    ratio_axis = ratio_axis + 0.25f;

    ratio_movement.y = -(ratio_axis / -0.25f);
    ratio_movement.x = (-0.25f - ratio_axis) / 0.25f;

    ratio_movement_strafe.y = -(-0.25f - ratio_axis) / 0.25f;
    ratio_movement_strafe.x = -(ratio_axis / -0.25f);
  } else if (
    ratio_axis <= -0.5f &&
    ratio_axis >= -0.75f
  ) {
    ratio_axis = ratio_axis + 0.5f;

    ratio_movement.y = -(-0.25f - ratio_axis) / -0.25f;
    ratio_movement.x = -(ratio_axis / 0.25f);

    ratio_movement_strafe.y = (ratio_axis / 0.25f);
    ratio_movement_strafe.x = -(-0.25f - ratio_axis) / -0.25f;
  } else {
    ratio_axis = ratio_axis + 0.75f;

    ratio_movement.y = (ratio_axis / -0.25f);
    ratio_movement.x = -(-0.25f - ratio_axis) / 0.25f;

    ratio_movement_strafe.y = (-0.25f - ratio_axis) / 0.25f;
    ratio_movement_strafe.x = (ratio_axis / -0.25f);
  }

  if (
    metil->input.controller_state.available == 1 &&
    metil->input.controller_state.left_stick.x != 0.0f ||
    metil->input.controller_state.left_stick.y != 0.0f
  ) {
    movement.x = (
      (metil->input.controller_state.left_stick.y * ratio_movement.x) +
      (metil->input.controller_state.left_stick.x * ratio_movement_strafe.x)
    );

    movement.z = (
      (metil->input.controller_state.left_stick.y * ratio_movement.y) +
      (metil->input.controller_state.left_stick.x * ratio_movement_strafe.y)
    );
  } else {
    struct math_c_vector2_float direction_arrows = {
      .x = (
        (
          metil->input.keydown_map[
            metil_keycode_right_arrow
          ] ||
          metil->input.keydown_map[
            metil_keycode_d
          ] ||
          metil->input.keydown_map[
            metil_keycode_single_quote
          ]
        ) - (
          metil->input.keydown_map[
            metil_keycode_left_arrow
          ] ||
          metil->input.keydown_map[
            metil_keycode_a
          ] ||
          metil->input.keydown_map[
            metil_keycode_l
          ]
        )
      ),
      .y = (
        (
          metil->input.keydown_map[
            metil_keycode_up_arrow
          ] ||
          metil->input.keydown_map[
            metil_keycode_w
          ] ||
          metil->input.keydown_map[
            metil_keycode_p
          ]
        ) - (
          metil->input.keydown_map[
            metil_keycode_down_arrow
          ] ||
          metil->input.keydown_map[
            metil_keycode_s
          ] ||
          metil->input.keydown_map[
            metil_keycode_semi_colon
          ]
        )
      )
    };

    if (
      direction_arrows.x != 0.0f &&
      direction_arrows.y != 0.0f
    ) {
      direction_arrows.x = (
        direction_arrows.x * 0.82f
      );

      direction_arrows.y = (
        direction_arrows.y * 0.82f
      );
    }

    movement.x = (
      direction_arrows.y * ratio_movement.x +
      direction_arrows.x * ratio_movement_strafe.x
    );

    movement.z = (
      direction_arrows.y * ratio_movement.y +
      direction_arrows.x * ratio_movement_strafe.y
    );
  }

  if (
    (
      metil->input.keydown_map[
        metil_keycode_space
      ] == 1 || (
        metil->input.controller_state.available == 1 &&
        metil->input.controller_state.cross >= 0.1f
      )
    ) &&
    metil_player->velocity.y == 0.0f
  ) {
    metil_player->velocity.y = (
      speed_original /
      1.25f
    );
  }

  metil_player->position.x = (
    metil_player->position.x + (
      movement.x *
      metil_player->speed_movement
    )
  );

  metil_player->position.y = (
    metil_player->position.y + (
      movement.y *
      metil_player->speed_movement
    ) + (
      metil_player->velocity.y *
      speed_delta
    )
  );

  metil_player->position.z = (
    metil_player->position.z + (
      movement.z *
      metil_player->speed_movement
    )
  );

  if (
    metil_player->position.y > metil_player->position_y_floor
  ) {
    metil_player->velocity.y = (
      metil_player->velocity.y -
      speed_original *
      speed_delta *
      5.0f
    );
  }

  if (
    metil_player->position.y < metil_player->position_y_floor
  ) {
    metil_player->position.y = (
      metil_player->position_y_floor
    );

    metil_player->velocity.y = 0.0f;
  }

  metil_player->speed_movement = (
    speed_original
  );
}
