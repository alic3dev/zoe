#ifndef __zoe_zoe_object_object_text_backing_h
#define __zoe_zoe_object_object_text_backing_h

#include <zoe_pipeline_index.h>

#include <metil_object/metil_object.h>

#include <math_c_vector.h>

#include <Metal/MTLDevice.h>

void object_text_backing_initialize(
  struct metil_object* _Nonnull,
  id<MTLDevice> _Nonnull,
  struct math_c_vector3_float* _Nonnull,
  struct math_c_vector3_float* _Nonnull,
  struct zoe_pipeline_index* _Nonnull
);

#endif
