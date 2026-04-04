#include <animation/zoe/animation_zoe_running.h>

#include <animation/zoe/animation_zoe_walking.h>
#include <model/model_zoe.h>

#include <metil_animation/metil_animation.h>
#include <metil_model/metil_model.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable_type.h>

void zoe_animation_zoe_running_initialize(
  struct metil_animation* metil_animation
) {
  metil_animation_initialize(
    metil_animation
  );

  metil_animation->length = (
    0x02ee
  );

  metil_animation->loops = (
    metil_animation_loop_loops
  );

  metil_animation->start = (
    zoe_animation_zoe_running_start
  );

  metil_animation->poll = (
    zoe_animation_zoe_running_poll
  );

  metil_animation->end = (
    zoe_animation_zoe_running_end
  );
}

void zoe_animation_zoe_running_start(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable
) {
  zoe_animation_zoe_walking_start(
    metil_animation,
    metil_renderable_type,
    metil_renderable
  );
}

void zoe_animation_zoe_running_poll(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable,
  float progress
) {
  zoe_animation_zoe_walking_poll(
    metil_animation,
    metil_renderable_type,
    metil_renderable,
    progress
  );
}

void zoe_animation_zoe_running_end(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable
) {
}
