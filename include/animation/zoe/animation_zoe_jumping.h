#ifndef __zoe_animation_zoe_animation_zoe_jumping_h
#define __zoe_animation_zoe_animation_zoe_jumping_h

#include <metil_animation/metil_animation.h>
#include <metil_rendering/metil_renderable_type.h>

void zoe_animation_zoe_jumping_initialize(
  struct metil_animation* _Nonnull
);

void zoe_animation_zoe_jumping_start(
  struct metil_animation* _Nonnull,
  enum metil_renderable_type,
  void* _Nonnull
);

void zoe_animation_zoe_jumping_poll(
  struct metil_animation* _Nonnull,
  enum metil_renderable_type,
  void* _Nonnull,
  float
);

void zoe_animation_zoe_jumping_end(
  struct metil_animation* _Nonnull,
  enum metil_renderable_type,
  void* _Nonnull
);

#endif
