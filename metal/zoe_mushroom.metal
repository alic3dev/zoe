#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

struct data_vertex {
  float4 position [[
    position
  ]];
  float3 colour;
  float brightness;
};

[[vertex]] struct data_vertex zoe_mushroom_vertex(
  const device simd_float4* positions [[
    buffer(
      metil_renderer_vertex_index_parameter_vertices
    )
  ]],
  constant struct metil_renderer_data_frame* data_frame [[
    buffer(
      metil_renderer_vertex_index_parameter_data_frame
    )
  ]],
  constant struct metil_renderer_data_object* data_object [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  unsigned int index_vertex [[
    vertex_id
  ]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    positions[
      index_vertex
    ]
  );

  data_vertex.brightness = (
    data_frame->brightness
  );

  if (
    index_vertex <=
    0x1388
  ) {
    data_vertex.colour.x = (
      0x01
    );

    data_vertex.colour.y = (
      0x01
    );

    data_vertex.colour.z = (
      0x01
    );

    if (
      (
        (
          index_vertex %
          0x20
        ) ==
        0x00
      ) &&
      (
        index_vertex >=
        0x64
      )
    ) {
      data_vertex.colour.x = (
        0x00
      );

      data_vertex.colour.y = (
        0x00
      );

      data_vertex.colour.z = (
        0x00
      );
    }
  } else {
    data_vertex.colour.x = (
      0x00
    );

    data_vertex.colour.y = (
      0x00
    );

    data_vertex.colour.z = (
      0x00
    );
  }

  return (
    data_vertex
  );
}

fragment float4 zoe_mushroom_fragment(
  struct data_vertex data_vertex [[
    stage_in
  ]]
) {
  return float4(
    (
      data_vertex.colour.x *
      data_vertex.brightness
    ),
    (
      data_vertex.colour.y *
      data_vertex.brightness
    ),
    (
      data_vertex.colour.z *
      data_vertex.brightness
    ),
    0x01
  );
}
