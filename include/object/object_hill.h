#ifndef __zoe_object_object_hill_h
#define __zoe_object_object_hill_h

#include <metil_object/metil_object.h>

#include <clic3_vector.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_object_hill_initialize(
  struct metil_object* _Nonnull,
  id<MTLTexture> _Nonnull,
  id<MTLTexture> _Nonnull,
  id<MTLDevice> _Nonnull
);

#endif
