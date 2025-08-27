#include <player.h>

#include <input/controller.h>
#include <input/cursor.h>
#include <input/keycodes.h>
#include <input/map.h>

#include <math.h>

void player_initialize(
  struct player* player
) {
  player->position.x = 0.0f;
  player->position.y = 0.0f;
  player->position.z = 0.0f;

  player->speed_movement = 0.2f;
  player->speed_rotation = (
    player->speed_movement / 4.0f
  );

  player->velocity.x = 0.0f;
  player->velocity.y = 0.0f;
  player->velocity.z = 0.0f;
}

void player_input_poll(
  struct player* player
) {
  struct controller_state controller_state;

  controller_poll(
    &controller_state
  );

  float speed_original = player->speed_movement;

  if (
    controller_state.available == 1 &&
    controller_state.trigger_left >= 0.1f &&
    controller_state.thumbstick_button_left == 0.0f
  ) {
    player->speed_movement = (
      player->speed_movement *
      controller_state.trigger_left +
      1.0f
    );
  } else if (
    controller_state.available == 1 &&
    controller_state.trigger_left < 0.1f &&
    controller_state.thumbstick_button_left >= 0.1f
  ) {
    player->speed_movement = (
      player->speed_movement / 2.0f
    );
  } else if (
    (
      input_map_keydown[
        keycode_option_right
      ] == 1 ||
      input_map_keydown[
        keycode_control
      ] == 1
    )  && (
      input_map_keydown[
        keycode_shift_left
      ] == 0 &&
      input_map_keydown[
        keycode_shift_right
      ] == 0
    )
  ) {
    player->speed_movement = (
      player->speed_movement / 2.0f
    );
  } else if (
    (
      input_map_keydown[
        keycode_option_right
      ] == 0 &&
      input_map_keydown[
        keycode_control
      ] == 0
    ) && (
      input_map_keydown[
        keycode_shift_left
      ] == 1 ||
      input_map_keydown[
        keycode_shift_right
      ] == 1 
    )
  ) {
    player->speed_movement = (
      player->speed_movement * 2.0f
    );
  }

  struct clic3_vector3_float movement = {
    .x = 0.0f,
    .y = 0.0f,
    .z = 0.0f
  };

  struct clic3_vector2_float ratio_movement = {
    .x = 0.0f,
    .y = 0.0f
  };

  struct clic3_vector2_float ratio_movement_strafe = {
    .x = 0.0f,
    .y = 0.0f
  };

  player->rotation.y = (
    player->rotation.y + (
      input_delta_cursor.x / 50.0f *
      player->speed_rotation
    )
  );

  player->rotation.z = (
    player->rotation.z + (
      input_delta_cursor.y / 50.0f *
      player->speed_rotation
    )
  );

  input_delta_cursor.x = 0;
  input_delta_cursor.y = 0;
  
  float ratio_axis = fmod(
    player->rotation.y,
    (M_PI * 2.0f)
  ) / (M_PI * 2.0f);

  if (ratio_axis >= 0.0f) {
    if (
      ratio_axis <= 0.25f
    ) {
      ratio_movement.y = (0.25f - ratio_axis) / 0.25f;
      ratio_movement.x = -(ratio_axis / 0.25f);
    } else if (
      ratio_axis >= 0.25f &&
      ratio_axis <= 0.5f 
    ) {
      ratio_axis = ratio_axis - 0.25f;

      ratio_movement.y = -(ratio_axis / 0.25f);
      ratio_movement.x = -(0.25f - ratio_axis) / 0.25f;
    } else if (
      ratio_axis >= 0.5f &&
      ratio_axis <= 0.75f 
    ) {
      ratio_axis = ratio_axis - 0.5f;

      ratio_movement.y = -(0.25f - ratio_axis) / 0.25f;
      ratio_movement.x = (ratio_axis / 0.25f);
    } else {
      ratio_axis = ratio_axis - 0.75f;

      ratio_movement.y = (ratio_axis / 0.25f);
      ratio_movement.x = (0.25f - ratio_axis) / 0.25f;
    }
  } else {
    if (
      ratio_axis >= -0.25f
    ) {
      ratio_movement.y = (-0.25f - ratio_axis) / -0.25f;
      ratio_movement.x = -(ratio_axis / 0.25f);
    } else if (
      ratio_axis <= -0.25f &&
      ratio_axis >= -0.5f
    ) {
      ratio_axis = ratio_axis + 0.25f;

      ratio_movement.y = -(ratio_axis / -0.25f);
      ratio_movement.x = -(-0.25f - ratio_axis) / 0.25f;
    } else if (
      ratio_axis <= -0.5f &&
      ratio_axis >= -0.75f 
    ) {
      ratio_axis = ratio_axis + 0.5f;

      ratio_movement.y = -(-0.25f - ratio_axis) / -0.25f;
      ratio_movement.x = (ratio_axis / 0.25f);
    } else {
      ratio_axis = ratio_axis + 0.75f;

      ratio_movement.y = (ratio_axis / -0.25f);
      ratio_movement.x = (-0.25f - ratio_axis) / 0.25f;
    }
  }

  ratio_axis = fmod(
    player->rotation.y,
    (M_PI * 2.0f)
  ) / (M_PI * 2.0f);

  if (ratio_axis >= 0.0f) {
    if (
      ratio_axis <= 0.25f
    ) {
      ratio_movement_strafe.y = -(ratio_axis / 0.25f);
      ratio_movement_strafe.x = -(0.25f - ratio_axis) / 0.25f;
    } else if (
      ratio_axis >= 0.25f &&
      ratio_axis <= 0.5f
    ) {
      ratio_axis = ratio_axis - 0.25f;

      ratio_movement_strafe.y = -(0.25f - ratio_axis) / 0.25f;
      ratio_movement_strafe.x = (ratio_axis / 0.25f);
    } else if (
      ratio_axis >= 0.5f &&
      ratio_axis <= 0.75f
    ) {
      ratio_axis = ratio_axis - 0.5f;

      ratio_movement_strafe.y = (ratio_axis / 0.25f);
      ratio_movement_strafe.x = (0.25f - ratio_axis) / 0.25f;
    } else {
      ratio_axis = ratio_axis - 0.75f;

      ratio_movement_strafe.y = (0.25f - ratio_axis) / 0.25f;
      ratio_movement_strafe.x = -(ratio_axis / 0.25f);
    }
  } else {
    if (
      ratio_axis >= -0.25f
    ) {
      ratio_movement_strafe.y = -(ratio_axis / 0.25f);
      ratio_movement_strafe.x = -(-0.25f - ratio_axis) / -0.25f;
    } else if (
      ratio_axis <= -0.25f &&
      ratio_axis >= -0.5f
    ) {
      ratio_axis = ratio_axis + 0.25f;

      ratio_movement_strafe.y = -(-0.25f - ratio_axis) / 0.25f;
      ratio_movement_strafe.x = (ratio_axis / -0.25f);
    } else if (
      ratio_axis <= -0.5f &&
      ratio_axis >= -0.75f
    ) {
      ratio_axis = ratio_axis + 0.5f;

      ratio_movement_strafe.y = (ratio_axis / 0.25f);
      ratio_movement_strafe.x = (-0.25f - ratio_axis) / -0.25f;
    } else {
      ratio_axis = ratio_axis + 0.75f;

      ratio_movement_strafe.y = (-0.25f - ratio_axis) / 0.25f;
      ratio_movement_strafe.x = -(ratio_axis / -0.25f);
    }
  }

  if (controller_state.available == 1) {
    if (
      controller_state.input_axis_x_right >= 0.1f || 
      controller_state.input_axis_x_right <= -0.1f
    ) {
      player->rotation.y = (
        player->rotation.y + (
          controller_state.input_axis_x_right *
          player->speed_rotation
        )
      );
    }

    if (
      controller_state.input_axis_y_right >= 0.1f || 
      controller_state.input_axis_y_right <= -0.1f
    ) {
      player->rotation.z = (
        player->rotation.z + (
          controller_state.input_axis_y_right *
          player->speed_rotation
        )
      );
    }

    movement.x = (
      (controller_state.input_axis_y_left * ratio_movement.x) +
      (controller_state.input_axis_x_left * ratio_movement_strafe.x)
    );

    movement.z = (
      (controller_state.input_axis_y_left * ratio_movement.y) +
      (controller_state.input_axis_x_left * ratio_movement_strafe.y)
    );
  }

  if (
    input_map_keydown[
      keycode_q
    ] == 1 ||
    input_map_keydown[
      keycode_e
    ] == 1 ||
    input_map_keydown[
      keycode_period
    ] == 1 ||
    input_map_keydown[
      keycode_slash
    ] == 1
  ) {
    movement.y = (
      input_map_keydown[
        keycode_q
      ] +
      -input_map_keydown[
        keycode_e
      ] + 
      input_map_keydown[
        keycode_period
      ] +
      -input_map_keydown[
        keycode_slash
      ]
    );

    if (movement.y > 1.0f) {
      movement.y = 1.0f;
    } else if (movement.y < -1.0f) {
      movement.y = -1.0f;
    }
  }

  if (
    input_map_keydown[
      keycode_left_arrow
    ] == 1 ||
    input_map_keydown[
      keycode_right_arrow
    ] == 1 ||
    input_map_keydown[
      keycode_a
    ] == 1 ||
    input_map_keydown[
      keycode_d
    ] == 1  ||
    input_map_keydown[
      keycode_down_arrow
    ] == 1 || 
    input_map_keydown[
      keycode_up_arrow
    ] == 1 || 
    input_map_keydown[
      keycode_s
    ] == 1 ||
    input_map_keydown[
      keycode_w
    ] == 1
  ) {
    movement.x = (
      (
        input_map_keydown[
          keycode_up_arrow
        ] || input_map_keydown[
          keycode_w
        ]
      ) * ratio_movement.x +
      -(
        input_map_keydown[
          keycode_down_arrow
        ] || 
        input_map_keydown[
          keycode_s
        ]
      ) * ratio_movement.x +
      (
        input_map_keydown[
          keycode_right_arrow
        ] || input_map_keydown[
          keycode_d
        ]
      ) * ratio_movement_strafe.x +
      -(
        input_map_keydown[
          keycode_left_arrow
        ] || input_map_keydown[
          keycode_a
        ]
      ) * ratio_movement_strafe.x
    );

    movement.z = (
      (
        input_map_keydown[
          keycode_up_arrow
        ] || input_map_keydown[
          keycode_w
        ]
      ) * ratio_movement.y +
      -(
        input_map_keydown[
          keycode_down_arrow
        ] || input_map_keydown[
          keycode_s
        ]
      ) * ratio_movement.y +
      (
        input_map_keydown[
          keycode_right_arrow
        ] || 
        input_map_keydown[
          keycode_d
        ]
      ) * ratio_movement_strafe.y + 
      -(
        input_map_keydown[
          keycode_left_arrow
        ] || input_map_keydown[
          keycode_a
        ]
      ) * ratio_movement_strafe.y
    );
  }

  if (
    input_map_keydown[
      keycode_space
    ] == 1 &&
    player->velocity.y == 0.0f
  ) {
    player->velocity.y = -(speed_original / 1.25f);
  }

  player->position.x = (
    player->position.x + (
      movement.x *
      player->speed_movement
    )
  );

  player->position.y = (
    player->position.y + (
      movement.y *
      player->speed_movement
    ) + player->velocity.y
  );

  player->position.z = (
    player->position.z + (
      movement.z *
      player->speed_movement
    )
  );

  if (player->position.y < -10.0f) {
    player->velocity.y = (
      player->velocity.y + (
        speed_original / 50.0f
      )
    );
  }

  if (player->position.y > -10.0f) {
    player->position.y = -10.0f;
    player->velocity.y = 0.0f;
  }

  player->speed_movement = speed_original;
}

void player_poll(
  struct player* player
) {}

void player_destroy(
  struct player* player
) {}
