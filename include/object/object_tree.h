#ifndef __zoe_object_object_tree_h
#define __zoe_object_object_tree_h

#include <metil_object/metil_object.h>

#include <clic3_vector.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_object_tree_initialize(
  struct metil_object* _Nonnull,
  struct clic3_vector2_float,
  id<MTLTexture> _Nonnull,
  id<MTLDevice> _Nonnull
);

#endif
