#include <animation/zoe/animation_zoe_jumping.h>

#include <model/model_zoe.h>

#include <metil_animation/metil_animation.h>
#include <metil_model/metil_model.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable_type.h>

void zoe_animation_zoe_jumping_initialize(
  struct metil_animation* metil_animation
) {
  metil_animation_initialize(
    metil_animation
  );

  metil_animation->length = (
    0x01f4
  );

  metil_animation->loops = (
    metil_animation_loop_none
  );

  metil_animation->start = (
    zoe_animation_zoe_jumping_start
  );

  metil_animation->poll = (
    zoe_animation_zoe_jumping_poll
  );

  metil_animation->end = (
    zoe_animation_zoe_jumping_end
  );

  metil_animation->data = (
    0x00
  );
}

void zoe_animation_zoe_jumping_start(
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

  metil_animation->data = (
    metil_animation->data +
    0x01
  );
}

void zoe_animation_zoe_jumping_poll(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable,
  float progress
) {
  struct metil_model* metil_model = (
    metil_renderable
  );

  enum zoe_model_joint_index index_joint_hip;
  enum zoe_model_joint_index index_joint_hip_inverse;
  enum zoe_model_joint_index index_joint_knee;
  enum zoe_model_joint_index index_joint_knee_inverse;
  enum zoe_model_joint_index index_joint_shoulder;
  enum zoe_model_joint_index index_joint_shoulder_inverse;
  enum zoe_model_joint_index index_joint_elbow;
  enum zoe_model_joint_index index_joint_elbow_inverse;

  if (
    (
      (unsigned long int)
      metil_animation->data %
      0x02
    ) ==
    0x00
  ) {
    index_joint_hip = (
      zoe_model_joint_index_hip_left
    );

    index_joint_hip_inverse = (
      zoe_model_joint_index_hip_right
    );

    index_joint_knee = (
      zoe_model_joint_index_knee_left
    );

    index_joint_knee_inverse = (
      zoe_model_joint_index_knee_right
    );

    index_joint_shoulder = (
      zoe_model_joint_index_shoulder_left
    );

    index_joint_shoulder_inverse = (
      zoe_model_joint_index_shoulder_right
    );

    index_joint_elbow = (
      zoe_model_joint_index_elbow_left
    );

    index_joint_elbow_inverse = (
      zoe_model_joint_index_elbow_right
    );
  } else {
    index_joint_hip = (
      zoe_model_joint_index_hip_right
    );

    index_joint_hip_inverse = (
      zoe_model_joint_index_hip_left
    );

    index_joint_knee = (
      zoe_model_joint_index_knee_right
    );

    index_joint_knee_inverse = (
      zoe_model_joint_index_knee_left
    );

    index_joint_shoulder = (
      zoe_model_joint_index_shoulder_right
    );

    index_joint_shoulder_inverse = (
      zoe_model_joint_index_shoulder_left
    );

    index_joint_elbow = (
      zoe_model_joint_index_elbow_right
    );

    index_joint_elbow_inverse = (
      zoe_model_joint_index_elbow_left
    );
  }

  metil_model->joints[
    index_joint_hip
  ].rotation.x = (
    -progress *
    0.3f
  );

  metil_model->joints[
    index_joint_hip_inverse
  ].rotation.x = (
    progress *
    0.1f
  );

  metil_model->joints[
    index_joint_knee
  ].rotation.x = (
    progress *
    0.5f
  );

  metil_model->joints[
    index_joint_knee_inverse
  ].rotation.x = (
    progress *
    0.4f
  );

  metil_model->joints[
    index_joint_shoulder
  ].rotation.x = (
    progress *
    0.1f
  );

  metil_model->joints[
    index_joint_shoulder_inverse
  ].rotation.x = (
    progress *
    0.4f
  );

  metil_model->joints[
    index_joint_elbow
  ].rotation.x = (
    -progress *
    0.9f
  );

  metil_model->joints[
    index_joint_elbow
  ].rotation.x = (
    -progress *
    0.8f
  );
}

void zoe_animation_zoe_jumping_end(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable
) {
}
