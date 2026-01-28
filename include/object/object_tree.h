#ifndef __zoe_object_object_tree_h
#define __zoe_object_object_tree_h

#include <math_c_vector.h>

#include <metil.h>
#include <metil_object/metil_object.h>

#include <Metal/MTLTexture.h>

void zoe_object_tree_initialize(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  struct metil_mesh* _Nullable,
  struct math_c_vector2_float,
  id<MTLTexture> _Nonnull,
  unsigned int
);

#endif
