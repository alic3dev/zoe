#include <group/group_text_with_backing.h>

#include <object/object_text_backing.h>

#include <zoe_pipeline_index.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_object/metil_object.h>
#include <metil_object/metil_object_text.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <math_c_maximum.h>

void group_text_with_backing_initialize(
  struct metil* metil,
  struct metil_group* metil_group_text_with_backing,
  char* text
) {
  metil_group_add_initialize(
    metil_group_text_with_backing,
    metil_renderable_type_object
  );

  metil_group_add_initialize(
    metil_group_text_with_backing,
    metil_renderable_type_object
  );

  struct metil_object* metil_object_text = (
    metil_group_text_with_backing->renderables[
      metil_group_text_with_backing->length -
      1
    ]->renderable
  );

  struct metil_object* metil_object_text_backing = (
    metil_group_text_with_backing->renderables[
      metil_group_text_with_backing->length -
      2
    ]->renderable
  );

  metil_object_text_initialize(
    metil,
    metil_object_text,
    text
  );

  metil_object_text->position.y = -(
    metil_object_text->mesh.size.y *
    8.0
  );

  object_text_backing_initialize(
    metil_object_text_backing,
    metil->renderer_interface.metal_device,
    &metil_object_text->mesh.size,
    &metil_object_text->position
  );

  metil_object_text->index_pipeline_render = (
    zoe_pipeline_index_text
  );

  metil_object_text_backing->index_pipeline_render = (
    zoe_pipeline_index_text_backing
  );

  metil_group_text_with_backing->visible = (
    0
  );
}

void group_text_with_backing_visibility_set(
  struct metil_group* metil_group_text_with_backing,
  float distance,
  float proximity
) {
  if (
    distance <= proximity
  ) {
    metil_group_text_with_backing->visible = (
      1
    );

    struct metil_object* metil_object_text_backing = (
      metil_group_text_with_backing->renderables[
        group_text_with_backing_index_text_backing
      ]->renderable
    );

    struct metil_object* metil_object_text = (
      metil_group_text_with_backing->renderables[
        group_text_with_backing_index_text
      ]->renderable
    );

    struct metil_renderer_data_object* metil_renderer_data_object_text_backing = (
      metil_object_text_backing->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    struct metil_renderer_data_object* metil_renderer_data_object_text = (
      metil_object_text->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    metil_renderer_data_object_text->color.w = (
      math_c_maximum_float(
        (
          (
            proximity -
            distance
          ) /
          proximity
        ),
        0.0f
      )
    );

    metil_renderer_data_object_text_backing->color.w = (
      metil_renderer_data_object_text->color.w
    );
  } else {
    metil_group_text_with_backing->visible = (
      0
    );
  }
}
