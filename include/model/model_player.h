#ifndef __zoe_model_player_h
#define __zoe_model_player_h

#include <metil.h>
#include <metil_model/metil_model.h>
#include <metil_rendering/metil_camera/metil_camera.h>

#include <math_c_vector.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

enum zoe_model_player_object_index {
  zoe_model_player_object_index_body = 0,
  zoe_model_player_object_index_head = 1
};

void zoe_model_player_initialize(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull,
  id<MTLTexture> _Nonnull,
  unsigned char
);

void zoe_model_player_poll(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

void zoe_model_player_mirror_poll(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

#endif
