#ifndef __zoe_zoe_renderables_renderables_static_h
#define __zoe_zoe_renderables_renderables_static_h

#include <metil.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable.h>

#define zoe_renderables_static_length_renderables 0x04

enum zoe_renderables_static_index_renderable {
  zoe_renderables_static_index_renderable_hint_control_movement_keyboard   = 0x00,
  zoe_renderables_static_index_renderable_hint_control_movement_controller = 0x01,
  zoe_renderables_static_index_renderable_hint_control_camera_keyboard     = 0x02,
  zoe_renderables_static_index_renderable_hint_control_camera_controller   = 0x03
};
struct zoe_renderables_static {
  struct metil_renderable renderables[
    zoe_renderables_static_length_renderables
  ];
};

void zoe_renderables_static_initialize(
  struct metil* _Nonnull,
  struct zoe_renderables_static* _Nonnull
);

void zoe_renderables_static_object_destroy_null(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull
);

void zoe_renderables_static_destroy(
  struct metil* _Nonnull,
  struct zoe_renderables_static* _Nonnull
);

#endif
