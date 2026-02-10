#include <mesh/mesh_zoe_body.h>

#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>

#include <metil_mesh/metil_mesh.h>

void mesh_zoe_body_initialize(
  struct metil_mesh* metil_mesh_zoe_body
) {
  metil_mesh_initialize(
    metil_mesh_zoe_body
  );

  // float height = 3.5f * 0.8f;

  // leg measurements

  float circumference_ankle = (
    2.0f
  );

  float diameter_ankle = (
    circumference_ankle / 
    math_c_pi
  );

  float length_leg = (
    // height /
    3.0f *
    circumference_ankle
  );

  float length_calf = (
    length_leg /
    2.0f
  );

  float length_thigh = (
    length_calf
  );

  float radius_ankle = (
    diameter_ankle /
    2.0f
  );

  float diameter_calf = (
    diameter_ankle *
    1.75f
  );

  float radius_calf = (
    diameter_calf /
    2.0f
  );

  float diameter_thigh = (
    diameter_ankle *
    2.1f
  );

  float radius_thigh = (
    diameter_thigh /
    2.0f
  );

  float diameter_hips = (
    diameter_thigh *
    2.0f
  );

  float radius_hips = (
    diameter_hips /
    2.0f
  );

  float offset_position_thigh_y = (
    length_calf
  );

  float length_torso = (
    length_leg *
    0.75f
  );

  float length_head = (
    length_leg *
    0.25f
  );

  // waist measurements
  float diameter_waist = (
    diameter_hips *
    0.90f
  );

  float radius_waist = (
    diameter_waist /
    2.0f
  );

  unsigned int length_segments_leg = 40;
  unsigned int length_segments_leg_radial = 40;
  unsigned int length_vertices_leg = (
    length_segments_leg *
    length_segments_leg_radial
  );

  unsigned int length_segments_waist = 40;
  unsigned int length_segments_waist_radial = 40;
  unsigned int length_vertices_torso = (
    length_segments_waist *
    length_segments_waist_radial
  );

  metil_mesh_zoe_body->length_indices = (
    length_vertices_leg *
    // 6 *
    2 * // 2 legs
    2 +
    length_vertices_torso *
    2
  );

  metil_mesh_zoe_body->length_vertices = (
    length_vertices_leg *
    2 +
    length_vertices_torso
  );

  clic3_memory_reallocate_raw(
    &metil_mesh_zoe_body->indices,
    (
      sizeof(
        unsigned int
      ) *
      metil_mesh_zoe_body->length_indices
    )
  );

  clic3_memory_reallocate_raw(
    &metil_mesh_zoe_body->vertices,
    (
      sizeof(
        struct math_c_vector4_float
      ) *
      metil_mesh_zoe_body->length_vertices
    )
  );

  unsigned long int index_vertex = (
    0
  );

  for (
    unsigned char index_leg = 0;
    index_leg < 2;
    ++index_leg
  ) {
    for (
      unsigned int index_vertex_leg = 0;
      index_vertex_leg < length_vertices_leg;
      ++index_vertex_leg
    ) {
      unsigned int index_segment_leg = (
        index_vertex_leg /
        length_segments_leg_radial
      );

      unsigned int index_segment_radial_leg = (
        index_vertex_leg %
        length_segments_leg_radial
      );

      float percentage_segment_leg = (
        (float) index_segment_leg /
        (float) (
          length_segments_leg -
          1
        )
      );

      float percentage_segment_radial_leg = (
        (float) index_segment_radial_leg /
        (float) (
          length_segments_leg_radial -
          1
        )
      );

      float radius = (
        0.0f
      );

      float position_leg_segment_y = (
        0.0f
      );

      if (
        percentage_segment_leg < 0.5f
      ) {
        float percentage_calf = (
          (float) index_segment_leg /
          (
            (float) length_segments_leg /
            2.0f
          )
        );

        if (
          percentage_calf > 0.5f
        ) {
          radius = (
            radius_calf -
            (
              1.0f -
              math_c_sine(
                (
                  percentage_calf *
                  math_c_pi
                ),
                math_c_pi
              )
            ) *
            radius_ankle *
            0.125f
          );
        } else {
          radius = (
            math_c_sine(
              (
                percentage_calf *
                math_c_pi
              ),
              math_c_pi
            ) *
            (
              radius_calf -
              radius_ankle
            ) +
            radius_ankle
          );
        }

        position_leg_segment_y = (
          length_calf *
          percentage_calf
        );
      } else {
        float percentage_thigh = (
          (
            percentage_segment_leg -
            0.5f
          ) /
          0.5f
        );

        radius = (
          percentage_thigh *
          (
            radius_thigh -
            radius_calf
          ) +
          (
            radius_calf -
            radius_ankle *
            0.125f *
            (
              1.0f -
              percentage_thigh
            )
          )
        );

        position_leg_segment_y = (
          offset_position_thigh_y +
          length_thigh *
          percentage_thigh
        );
      }

      float angle = (
        percentage_segment_radial_leg *
        math_c_pi_doubled
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].x = (
        math_c_sine(
          angle,
          math_c_pi
        ) *
        radius
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].y = (
        position_leg_segment_y
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].z = (
        math_c_cosine(
          angle,
          math_c_pi
        ) *
        radius
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].w = (
        1.0f
      );

      if (
        percentage_segment_leg < 0.5f
      ) {
        radius = (
          radius_calf
        );
      } else {
        if (
          percentage_segment_leg < 0.6f
        ) {
          percentage_segment_leg = (
            percentage_segment_leg +
            // 0.125f
            0
          );
        }

        radius = (
          radius +
          math_c_sine(
            (
              (
                percentage_segment_leg -
                0.5f
              ) /
              0.5f *
              math_c_pi
            ),
            math_c_pi
          ) *
          radius_ankle *
          0.1f
        );
      }

      if (
        index_leg == 0
      ) {
        metil_mesh_zoe_body->vertices[
          index_vertex
        ].x = -(
          metil_mesh_zoe_body->vertices[
            index_vertex
          ].x -
          radius
        );
      } else {
        metil_mesh_zoe_body->vertices[
          index_vertex
        ].x = -(
          metil_mesh_zoe_body->vertices[
            index_vertex
          ].x +
          radius
        );
      }
      
      index_vertex = (
        index_vertex +
        1
      );
    }
  }

  for (
    unsigned int index_vertex_torso = 0;
    index_vertex_torso < length_vertices_torso;
    ++index_vertex_torso
  ) {
    unsigned int index_segment_waist = (
      index_vertex_torso /
      length_segments_waist_radial
    );

    unsigned int index_segment_radial_waist = (
      index_vertex_torso %
      length_segments_waist_radial
    );

    float percentage_segment_waist = (
      (float) index_segment_waist /
      (float) (
        length_segments_waist -
        1
      )
    );

    float percentage_segment_radial_waist = (
      (float) index_segment_radial_waist /
      (float) (
        length_segments_waist_radial -
        1
      )
    );

    float asdf = (
      math_c_sine(
        (
          percentage_segment_waist *
          math_c_pi
        ),
        math_c_pi
      )
    );

    float radius = (
      (
        radius_hips *
        (
          1.0f -
          asdf
        )
      ) +
      (
        radius_waist *
        asdf
      )
    );

    float angle = (
      percentage_segment_radial_waist *
      math_c_pi_doubled
    );

    metil_mesh_zoe_body->vertices[
      index_vertex
    ].x = (
      math_c_sine(
        angle,
        math_c_pi
      ) *
      radius
    );

    metil_mesh_zoe_body->vertices[
      index_vertex
    ].y = (
      length_leg +
      (
        percentage_segment_waist *
        length_torso
      )
    );

    metil_mesh_zoe_body->vertices[
      index_vertex
    ].z = (
      math_c_cosine(
        angle,
        math_c_pi
      ) *
      radius *
      0.6f
    );

    metil_mesh_zoe_body->vertices[
      index_vertex
    ].w = (
      1.0f
    );

    index_vertex = (
      index_vertex +
      1
    );
  }

  for (
    unsigned int index_indices = 0;
    index_indices < metil_mesh_zoe_body->length_indices;
    ++index_indices
  ) {
    metil_mesh_zoe_body->indices[
      index_indices
    ] = (
      index_indices /
      2 +
      (
        index_indices %
        2
      )
    );
  }


}
