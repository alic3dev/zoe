#ifndef __zoe_object_object_player_h
#define __zoe_object_object_player_h

#include <metil_object/metil_object.h>

#include <clic3_vector.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_object_player_initialize(
  struct metil_object* _Nonnull,
  id<MTLTexture> _Nonnull,
  id<MTLDevice> _Nonnull,
  unsigned char
);

void zoe_object_player_poll(
  struct metil_object* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  float* _Nonnull
);

void zoe_object_player_mirror_poll(
  struct metil_object* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  float* _Nonnull
);

#endif
