#include <zoe_animation/zoe/animation_zoe_idle.h>

#include <zoe_model/model_zoe.h>

#include <math_c_pi.h>
#include <math_c_sine.h>

#include <metil_animation/metil_animation.h>
#include <metil_model/metil_model.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable_type.h>

void zoe_animation_zoe_idle_initialize(
  struct metil_animation* metil_animation
) {
  metil_animation_initialize(
    metil_animation
  );

  metil_animation->length = (
    0x1f40
  );

  metil_animation->loops = (
    metil_animation_loop_loops
  );

  metil_animation->start = (
    zoe_animation_zoe_idle_start
  );

  metil_animation->poll = (
    zoe_animation_zoe_idle_poll
  );

  metil_animation->end = (
    zoe_animation_zoe_idle_end
  );
}

void zoe_animation_zoe_idle_start(
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

void zoe_animation_zoe_idle_poll(
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
        math_c_pi *
        0x04
      ),
      math_c_pi
    )
  );

  metil_model->joints[
    zoe_model_joint_index_shoulder_right
  ].rotation.x = (
    (
      progress_sine *
      2.0f
    ) *
    0.025f
  );

  metil_model->joints[
    zoe_model_joint_index_shoulder_left
  ].rotation.x = (
    -metil_model->joints[
      zoe_model_joint_index_shoulder_right
    ].rotation.x
  );
  
  progress_sine = (
    math_c_sine(
      (
        progress *
        math_c_pi
      ),
      math_c_pi
    )
  );

  metil_model->joints[
    zoe_model_joint_index_elbow_right
  ].rotation.x = (
    -progress_sine *
    0.1f
  );

  metil_model->joints[
    zoe_model_joint_index_elbow_left
  ].rotation.x = (
    metil_model->joints[
      zoe_model_joint_index_elbow_right
    ].rotation.x
  );

  if (
    progress_sine <
    0.5f
  ) {
    metil_model->joints[
      zoe_model_joint_index_hip_left
    ].rotation.x = (
      (
        (
          0.5f-
          progress_sine
        ) /
        0.5f
      ) *
      0.075f
    );

    metil_model->joints[
      zoe_model_joint_index_hip_right
    ].rotation.x = (
      0.0f
    );
  } else {
    metil_model->joints[
      zoe_model_joint_index_hip_left
    ].rotation.x = (
      0.0f
    );

    metil_model->joints[
      zoe_model_joint_index_hip_right
    ].rotation.x = (
      (
        0.0f +
        (
          progress_sine -
          0.5f
        )
      ) /
      0.5f *
      0.075f
    );
  }
}

void zoe_animation_zoe_idle_end(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable
) {
}
