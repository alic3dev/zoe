#include <zoe_renderables/renderables_static.h>

#include <metil.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_rectangle.h>
#include <metil_object.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>

void zoe_renderables_static_initialize(
  struct metil* metil,
  struct zoe_renderables_static* zoe_renderables_static
) {
  for (
    unsigned char index_renderable = (
      0x00
    );
    (
      index_renderable <
      zoe_renderables_static_length_renderables
    );
    ++index_renderable
  ) {
    struct metil_renderable* metil_renderable = (
      &zoe_renderables_static->renderables[
        index_renderable
      ]
    );

    switch (
      index_renderable
    ) {
      case zoe_renderables_static_index_renderable_hint_control_movement_keyboard:
      case zoe_renderables_static_index_renderable_hint_control_movement_controller:
      case zoe_renderables_static_index_renderable_hint_control_camera_keyboard:
      case zoe_renderables_static_index_renderable_hint_control_camera_controller: {
        metil_renderable_initialize(
          metil_renderable,
          metil_renderable_type_object
        );

        struct metil_object* metil_object = (
          metil_renderable->renderable
        );

        metil_mesh_rectangle_initialize(
          &metil_object->mesh,
          (struct math_c_vector2_float) {
            .x = (
              1.0f
            ),
            .y = (
              1.0f
            )
          }
        );

        metil_object_buffers_initialize(
          metil_object,
          metil->renderer_interface.metal_device
        );

        metil_object->destroy = (
          zoe_renderables_static_object_destroy_null
        );

        break;
      }
    }
  }
}

void zoe_renderables_static_object_destroy_null(
  struct metil* metil,
  struct metil_object* metil_object
) {
}

void zoe_renderables_static_destroy(
  struct metil* metil,
  struct zoe_renderables_static* zoe_renderables_static
) {
  for (
    unsigned char index_renderable = (
      0x00
    );
    (
      index_renderable <
      zoe_renderables_static_length_renderables
    );
    ++index_renderable
  ) {
    struct metil_renderable* metil_renderable = (
      &zoe_renderables_static->renderables[
        index_renderable
      ]
    );

    switch (
      index_renderable
    ) {
      case zoe_renderables_static_index_renderable_hint_control_movement_keyboard:
      case zoe_renderables_static_index_renderable_hint_control_movement_controller:
      case zoe_renderables_static_index_renderable_hint_control_camera_keyboard:
      case zoe_renderables_static_index_renderable_hint_control_camera_controller: {
        struct metil_object* metil_object = (
          metil_renderable->renderable
        );

        metil_object->destroy = (
          metil_object_destroy_with_textures
        );

        metil_object_destroy(
          metil,
          metil_object
        );

        break;
      }
    }
  }
}
