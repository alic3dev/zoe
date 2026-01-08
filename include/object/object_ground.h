#ifndef __zoe_object_object_ground_h
#define __zoe_object_object_ground_h

#include <metil_object/metil_object.h>

#include <math_c_vector.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_object_ground_initialize(
  struct metil_object* _Nonnull,
  struct math_c_vector3_float,
  id<MTLTexture> _Nonnull,
  id<MTLTexture> _Nonnull,
  id<MTLDevice> _Nonnull
);

#endif
