#ifndef __zoe_object_object_hill_h
#define __zoe_object_object_hill_h

#include <zoe_pipeline_index.h>

#include <math_c_vector.h>

#include <simd/simd.h>
struct zoe_data_object_hill {
  struct math_c_vector3_float position;
  struct math_c_vector3_float size;

  matrix_float4x4 view_model_matrix_projection;

  float lighting[
    0x014d
  ];
};

#ifndef __METAL_VERSION__
#include <metil.h>
#include <metil_rendering/metil_camera/metil_camera.h>
#include <metil_object/metil_object.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_object_hill_initialize(
  struct metil_object* _Nonnull,
  id<MTLTexture> _Nonnull,
  id<MTLTexture> _Nonnull,
  id<MTLTexture> _Nonnull,
  struct zoe_pipeline_index* _Nonnull,
  id<MTLDevice> _Nonnull
);

void zoe_object_hill_poll(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

#endif

#endif
