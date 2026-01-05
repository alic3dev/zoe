#ifndef __object_object_text_backing_h
#define __object_object_text_backing_h

#include <metil_object/metil_object.h>

#include <clic3_vector.h>

#include <Metal/MTLDevice.h>

void object_text_backing_initialize(
  struct metil_object* _Nonnull,
  id<MTLDevice> _Nonnull,
  struct clic3_vector3_float* _Nonnull,
  struct clic3_vector3_float* _Nonnull
);

#endif
