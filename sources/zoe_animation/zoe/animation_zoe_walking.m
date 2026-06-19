#include <zoe_animation/zoe/animation_zoe_walking.h>

#include <zoe_model/model_zoe.h>

#include <math_c_absolute.h>
#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metil_animation/metil_animation.h>
#include <metil_model/metil_model.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable_type.h>

void zoe_animation_zoe_walking_initialize(
  struct metil_animation* metil_animation
) {
  metil_animation_initialize(
    metil_animation
  );

  metil_animation->loops = (
    metil_animation_loop_loops
  );

  metil_animation->start = (
    zoe_animation_zoe_walking_start
  );

  metil_animation->poll = (
    zoe_animation_zoe_walking_poll
  );

  metil_animation->end = (
    zoe_animation_zoe_walking_end
  );
}

void zoe_animation_zoe_walking_start(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable
) {
  struct metil_model* metil_model = (
    metil_renderable
  );

  metil_joint_propagate_reset(
    &metil_model->joints[
      zoe_model_joint_index_neck
    ]
  );
}

void zoe_animation_zoe_walking_poll(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable,
  float progress
) {
  struct metil_model* metil_model = (
    metil_renderable
  );

  float progress_sine = (
    math_c_sine(
      (
        progress *
        math_c_pi_doubled
      ),
      math_c_pi
    )
  );

  if (
    progress <=
    0.5f
  ) {
    metil_model->joints[
      zoe_model_joint_index_hip_left
    ].rotation.x = (
      -progress_sine *
      0.5f
    );

    metil_model->joints[
      zoe_model_joint_index_knee_left
    ].rotation.x = (
      progress_sine *
      0.6f
    );

    metil_model->joints[
      zoe_model_joint_index_hip_right
    ].rotation.x = (
      progress_sine *
      0.25f
    );

    metil_model->joints[
      zoe_model_joint_index_knee_right
    ].rotation.x = (
      progress_sine *
      0.3f
    );
  } else {
    metil_model->joints[
      zoe_model_joint_index_hip_left
    ].rotation.x = (
      -progress_sine *
      0.25f
    );

    metil_model->joints[
      zoe_model_joint_index_knee_left
    ].rotation.x = (
      -progress_sine *
      0.3f
    );

    metil_model->joints[
      zoe_model_joint_index_hip_right
    ].rotation.x = (
      progress_sine *
      0.5f
    );

    metil_model->joints[
      zoe_model_joint_index_knee_right
    ].rotation.x = (
      -progress_sine *
      0.6f
    );
  }

  metil_model->joints[
    zoe_model_joint_index_shoulder_left
  ].rotation.x = (
    progress_sine *
    0.3f
  );

  metil_model->joints[
    zoe_model_joint_index_shoulder_right
  ].rotation.x = (
    -progress_sine *
    0.3f
  );

  metil_model->joints[
    zoe_model_joint_index_elbow_left
  ].rotation.x = (
    math_c_absolute_float(
      progress_sine
    ) *
    -0.3f
  );

  metil_model->joints[
    zoe_model_joint_index_elbow_right
  ].rotation.x = (
    math_c_absolute_float(
      progress_sine
    ) *
    -0.3f
  );
}

void zoe_animation_zoe_walking_end(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable
) {
}
