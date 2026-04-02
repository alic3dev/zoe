#ifndef __zoe_model_model_zoe_h
#define __zoe_model_model_zoe_h

#include <metil.h>
#include <metil_model/metil_model.h>
#include <metil_rendering/metil_camera/metil_camera.h>

#define zoe_model_length_joints 0x0e

enum zoe_model_joint_index {
  zoe_model_joint_index_neck = 0x00,
  zoe_model_joint_index_shoulder_left = 0x01,
  zoe_model_joint_index_shoulder_right = 0x02,
  zoe_model_joint_index_elbow_left = 0x03,
  zoe_model_joint_index_elbow_right = 0x04,
  zoe_model_joint_index_wrist_left = 0x05,
  zoe_model_joint_index_wrist_right = 0x06,
  zoe_model_joint_index_hips = 0x07,
  zoe_model_joint_index_hip_left = 0x08,
  zoe_model_joint_index_hip_right = 0x09,
  zoe_model_joint_index_knee_left = 0x0a,
  zoe_model_joint_index_knee_right = 0x0b,
  zoe_model_joint_index_ankle_left = 0x0c,
  zoe_model_joint_index_ankle_right = 0x0d
};

void zoe_model_zoe_initialize(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull
);

void zoe_model_zoe_poll(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

#endif
