#include <mesh/mesh_zoe_body.h>

#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>

#include <metil_mesh/metil_mesh.h>

#include <stdio.h>

void mesh_zoe_body_initialize(
  struct metil_mesh* metil_mesh_zoe_body
) {
  metil_mesh_initialize(
    metil_mesh_zoe_body
  );

  // float height = 3.5f * 0.8f;

  // leg measurements

  float diameter_ankle = (
    1.0f
  );

  float length_leg = (
    // height /
    3.0f *
    diameter_ankle
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
    1.6f
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

  float gap_thigh = (
    // diameter_ankle *
    // 0.25f
    0.0f
  );

  float diameter_hips = (
    diameter_thigh *
    2.0f +
    gap_thigh
  );

  float radius_hip = (
    diameter_hips /
    2.0f
  );

  float offset_position_thigh_y = (
    length_calf
  );

  // waist measurements
  float diameter_waist = (
    diameter_hips *
    0.95f
  );

  unsigned int length_segments_leg = 40;
  unsigned int length_segments_leg_radial = 40;
  unsigned int length_vertices_leg = (
    length_segments_leg *
    length_segments_leg_radial
  );

  metil_mesh_zoe_body->length_indices = (
    length_vertices_leg *
    // 6 *
    2 * // 2 legs
    2
  );

  metil_mesh_zoe_body->length_vertices = (
    length_vertices_leg *
    2
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

  unsigned int index_vertex = (
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
            0.125f
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
            0.125f
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
