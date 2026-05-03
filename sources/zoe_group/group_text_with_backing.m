#include <zoe_group/group_text_with_backing.h>

#include <zoe_data/data_zoe.h>
#include <zoe_object/object_text_backing.h>
#include <zoe_pipeline_index.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_object/metil_object.h>
#include <metil_object/metil_object_text.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <math_c_minimum.h>
#include <math_c_maximum.h>

void group_text_with_backing_initialize(
  struct metil* metil,
  struct metil_group* metil_group_text_with_backing,
  char* text
) {
  struct zoe_data_zoe* zoe_data_zoe = (
    metil->data
  );

  struct zoe_pipeline_index* zoe_pipeline_index = &(
    zoe_data_zoe->pipeline_index
  );

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
      0x01
    ]->renderable
  );

  struct metil_object* metil_object_text_backing = (
    metil_group_text_with_backing->renderables[
      metil_group_text_with_backing->length -
      0x02
    ]->renderable
  );

  metil_object_text_initialize(
    metil,
    metil_object_text,
    text
  );

  metil_object_text->position.y = (
    -0.75f +
    metil_object_text->mesh.size.y /
    0x02
  );

  object_text_backing_initialize(
    metil_object_text_backing,
    metil->renderer_interface.metal_device,
    &metil_object_text->mesh.size,
    &metil_object_text->position,
    zoe_pipeline_index
  );

  metil_object_text->index_pipeline_render = (
    zoe_pipeline_index->text
  );

  metil_group_text_with_backing->visible = (
    0x00
  );
}

void group_text_with_backing_visibility_set(
  struct metil_group* metil_group_text_with_backing,
  float distance,
  float proximity
) {
  group_text_with_backing_visibility_minimum_maximum_set(
    metil_group_text_with_backing,
    distance,
    proximity,
    0x00
  );
}

void group_text_with_backing_visibility_minimum_maximum_set(
  struct metil_group* metil_group_text_with_backing,
  float distance,
  float minimum,
  float maximum
) {
  float difference = (
    minimum -
    maximum
  );

  if (
    distance <= minimum
  ) {
    metil_group_text_with_backing->visible = (
      0x01
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

    metil_renderer_data_object_text->colour.w = (
      math_c_minimum_float(
        math_c_maximum_float(
          (
            (
              difference -
              (
                distance -
                maximum
              )
            ) /
            difference
          ),
          0x00
        ),
        0x01
      )
    );

    metil_renderer_data_object_text_backing->colour.w = (
      metil_renderer_data_object_text->colour.w
    );
  } else {
    metil_group_text_with_backing->visible = (
      0x00
    );
  }
}
