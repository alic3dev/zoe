#include <animation/zoe/animation_zoe_sneaking.h>

#include <metil_animation/metil_animation.h>
#include <metil_model/metil_model.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable_type.h>

void zoe_animation_zoe_sneaking_initialize(
  struct metil_animation* metil_animation
) {
  metil_animation_initialize(
    metil_animation
  );

  metil_animation->loops = (
    metil_animation_loop_loops
  );

  metil_animation->start = (
    zoe_animation_zoe_sneaking_start
  );

  metil_animation->poll = (
    zoe_animation_zoe_sneaking_poll
  );

  metil_animation->end = (
    zoe_animation_zoe_sneaking_end
  );
}

void zoe_animation_zoe_sneaking_start(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable
) {
  
}

void zoe_animation_zoe_sneaking_poll(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable,
  float progress
) {
}

void zoe_animation_zoe_sneaking_end(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable
) {
}  
