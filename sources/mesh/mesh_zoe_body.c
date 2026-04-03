#include <mesh/mesh_zoe_body.h>

#include <clic3_memory.h>

#include <math_c_absolute.h>
#include <math_c_minimum.h>
#include <math_c_maximum.h>
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

  // leg measurements

  float circumference_ankle = (
    2.0f
  );

  float diameter_ankle = (
    circumference_ankle /
    math_c_pi
  );

  float length_foot = (
    circumference_ankle
  );

  float diameter_foot = (
    diameter_ankle
  );

  float radius_foot = (
    diameter_ankle /
    2.0f
  );

  float length_leg = (
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

  float length_hips = (
    length_leg *
    0.2f
  );

  float diameter_hips = (
    diameter_thigh *
    2.0f
  );

  float radius_hips = (
    diameter_hips /
    2.0f
  );

  float radius_butt = (
    radius_hips *
    0.2f
  );

  float offset_position_thigh_y = (
    length_calf
  );

  float length_torso = (
    length_leg *
    0.55f
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

  // arm measurements
  float radius_shoulder = (
    radius_ankle
  );

  float diameter_shoulder = (
    radius_shoulder *
    2.0f
  );

  float length_arm = (
    (
      length_torso +
      length_hips
    )
  );

  float length_shoulder = (
    radius_ankle
  );

  float length_upper_arm = (
    length_arm /
    2.0f
  );

  float length_forearm = (
    length_upper_arm
  );

  float radius_upperarm = (
    radius_ankle *
    1.1f
  );

  float radius_elbow = (
    radius_ankle *
    0.95f
  );

  float radius_forearm = (
    radius_ankle *
    1.0f
  );

  float radius_wrist = (
    radius_ankle *
    0.8f
  );

  float radius_hand = (
    radius_wrist *
    1.25f
  );

  float radius_finger = (
    radius_hand *
    0.225f
  );

  float radius_thumb = (
    radius_finger *
    1.25f
  );

  float length_hand = (
    length_forearm /
    3.0f
  );

  float length_finger_index = (
    length_hand
  );

  float length_finger_middle = (
    length_finger_index *
    1.125f
  );

  float length_finger_ring = (
    length_finger_index *
    0.9875f
  );

  float length_finger_pinky = (
    length_finger_index *
    0.98f
  );

  metil_mesh_zoe_body->size.x = (
    (
      diameter_hips +
      radius_upperarm *
      0x02
    ) *
    0x02
  );

  metil_mesh_zoe_body->size.y = (
    length_leg +
    length_hips +
    length_torso
  );

  float multiplier_vertex = (
    mesh_zoe_body_multiplier_vertex
  );

  unsigned int length_segments_default = (
    mesh_zoe_body_length_segments
  );

  unsigned int length_segments_foot = (
    mesh_zoe_body_length_segments_foot
  );

  unsigned int length_segments_foot_radial = (
    mesh_zoe_body_length_segments_foot_radial
  );

  unsigned int length_vertices_foot = (
    mesh_zoe_body_length_vertices_foot
  );

  unsigned int length_segments_leg = (
    mesh_zoe_body_length_segments_leg
  );

  unsigned int length_segments_leg_radial = (
    mesh_zoe_body_length_segments_leg_radial
  );

  unsigned int length_vertices_leg = (
    mesh_zoe_body_length_vertices_leg
  );

  unsigned int length_segments_hips = (
    mesh_zoe_body_length_segments_hips
  );

  unsigned int length_segments_hips_radial = (
    mesh_zoe_body_length_segments_hips_radial
  );

  unsigned int length_vertices_hips = (
    mesh_zoe_body_length_vertices_hips
  );

  unsigned int length_segments_waist = (
    mesh_zoe_body_length_segments_waist
  );

  unsigned int length_segments_waist_radial = (
    mesh_zoe_body_length_segments_waist_radial
  );

  unsigned int length_vertices_torso = (
    mesh_zoe_body_length_vertices_torso
  );

  unsigned int length_segments_upper_arm = (
    mesh_zoe_body_length_segments_upper_arm
  );

  unsigned int length_segments_upper_arm_radial = (
    mesh_zoe_body_length_segments_upper_arm_radial
  );

  unsigned int length_vertices_upper_arm = (
    mesh_zoe_body_length_vertices_upper_arm
  );

  unsigned int length_segments_forearm = (
    mesh_zoe_body_length_segments_forearm
  );

  unsigned int length_segments_forearm_radial = (
    mesh_zoe_body_length_segments_forearm_radial
  );

  unsigned int length_vertices_forearm = (
    mesh_zoe_body_length_vertices_forearm
  );

  unsigned int length_segments_shoulder = (
    mesh_zoe_body_length_segments_shoulder
  );

  unsigned int length_segments_shoulder_radial = (
    mesh_zoe_body_length_segments_shoulder_radial
  );

  unsigned int length_vertices_shoulder = (
    mesh_zoe_body_length_vertices_shoulder
  );

  unsigned int length_vertices_arm = (
    mesh_zoe_body_length_vertices_arm
  );

  metil_mesh_zoe_body->length_indices = (
    (
      length_vertices_leg *
      0x02 +
      length_vertices_hips +
      length_vertices_torso +
      (
        length_vertices_shoulder +
        length_vertices_arm
      ) *
      0x02
    ) *
    0x03
  );

  metil_mesh_zoe_body->length_vertices = (
    mesh_zoe_body_length_vertices
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

  float offset_height = (
    0.0f
  );

  offset_height = (
    radius_foot
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

      float percentage_thigh = (
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
        percentage_thigh = (
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

      float radius_x = (
        radius
      );

      float radius_z = (
        radius
      );

      if (
        percentage_thigh >= 0.9f
      ) {
        radius_x = (
          radius_x +
          radius_x *
          (0.1f - (1.0f - percentage_thigh)) *
          0.04f
        );

        if (
          percentage_segment_radial_leg >= 0.25f &&
          percentage_segment_radial_leg <= 0.75f &&
          (
            (
              index_leg == 0 &&
              percentage_segment_radial_leg >= 0.5f
            ) ||
            (
              index_leg == 1 &&
              percentage_segment_radial_leg <= 0.5f
            )
          )
        ) {
          radius_z = (
            radius_z -
            radius_z *
            (0.1f - (1.0f - percentage_thigh)) *
            (
              (
                1.0f -
                math_c_sine(
                  percentage_segment_radial_leg / 0.5f * math_c_pi_half,
                  math_c_pi
                )
              ) *
              20.0f
            )
          );
        }
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
        radius_x
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].y = (
        position_leg_segment_y +
        offset_height
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].z = (
        math_c_cosine(
          angle,
          math_c_pi
        ) *
        radius_z
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].w = (
        1.0f
      );

      if (
        percentage_segment_leg >= 0.5f
      ) {
        radius_x = (
          radius_x +
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
          radius_x
        );
      } else {
        metil_mesh_zoe_body->vertices[
          index_vertex
        ].x = -(
          metil_mesh_zoe_body->vertices[
            index_vertex
          ].x +
          radius_x
        );
      }

      index_vertex = (
        index_vertex +
        1
      );
    }
  }

  offset_height = (
    offset_height +
    length_leg
  );

  for (
    unsigned int index_vertex_hips = 0;
    index_vertex_hips < length_vertices_hips;
    ++index_vertex_hips
  ) {
    unsigned int index_segment_hips = (
      index_vertex_hips /
      length_segments_hips_radial
    );

    unsigned int index_segment_radial_hips = (
      index_vertex_hips %
      length_segments_hips_radial
    );

    float percentage_segment_hips = (
      (float) index_segment_hips /
      (float) (
        length_segments_hips -
        1
      )
    );

    float percentage_segment_radial_hips = (
      (float) index_segment_radial_hips /
      (float) (
        length_segments_hips_radial -
        1
      )
    );

    float radius = (
      radius_hips
    );

    float angle = (
      percentage_segment_radial_hips *
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
      offset_height +
      (
        percentage_segment_hips *
        length_hips
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

    float percentage_width = (
      (
        metil_mesh_zoe_body->vertices[
          index_vertex
        ].x +
        radius
      ) /
      (
        radius *
        2.0f
      )
    );

    if (
      metil_mesh_zoe_body->vertices[
        index_vertex
      ].z > 0.0f
    ) {
      if (
        percentage_width >= 0.15f &&
        percentage_width <= 0.85f
      ) {

        if (
          percentage_segment_hips <= 0.25f
        ) {
          metil_mesh_zoe_body->vertices[
            index_vertex
          ].z = (
            metil_mesh_zoe_body->vertices[
              index_vertex
            ].z -
            metil_mesh_zoe_body->vertices[
              index_vertex
            ].z *
            math_c_minimum_float(
              1.0f,
              (1.0f - (
                  percentage_segment_hips / 0.25f)) *
              math_c_absolute_float(
                math_c_tangent(
                  (
                    (
                      percentage_width -
                      0.15f
                    ) /
                    0.7f *
                    math_c_pi
                  ),
                  math_c_pi
                )
              ) /
              8.0f
            ) *
            (
              (0.25f - percentage_segment_hips) / 0.25f
            )
          );
        }
      }
    } else {
      float radius_butt_value = (
        math_c_sine(
          math_c_sine(
          (
            math_c_sine(
              (
                percentage_segment_hips *
                math_c_pi_half
              ),
              math_c_pi
            ) *
            math_c_pi
          ),
          math_c_pi),
          math_c_pi
        ) *
        radius_butt
      );

      float percentage_buttocks_width = (
        percentage_width
      );

      if (
        percentage_buttocks_width > 0.5f
      ) {
        percentage_buttocks_width = (
          (
            percentage_buttocks_width -
            0.5f
          ) /
          0.5f
        );
      } else {
        percentage_buttocks_width = (
          percentage_buttocks_width /
          0.5f
        );
      }

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].z = (
        metil_mesh_zoe_body->vertices[
          index_vertex
        ].z -
        (
          math_c_sine(
            (
              percentage_buttocks_width *
              math_c_pi
            ),
            math_c_pi
          )
        ) *
        radius_butt_value
      );

      if (
        percentage_width >= 0.25f &&
        percentage_width <= 0.75f
      ) {
        metil_mesh_zoe_body->vertices[
          index_vertex
        ].z = (
          metil_mesh_zoe_body->vertices[
            index_vertex
          ].z -
          metil_mesh_zoe_body->vertices[
            index_vertex
          ].z *
          math_c_minimum_float(
            1.0f,
            (
              1.0f -
              math_c_sine(
                (
                  percentage_segment_hips *
                  math_c_pi_half
                ),
                math_c_pi
              )
            ) *
            math_c_absolute_float(
              math_c_tangent(
                (
                  (
                    percentage_width -
                    0.25f
                  ) /
                  0.5f *
                  math_c_pi
                ),
                math_c_pi
              )
            ) /
            8.0f
          ) *
          (1.0f - percentage_segment_hips)
        );
      }
    }

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

  offset_height = (
    offset_height +
    length_hips
  );

  for (
    unsigned int index_vertex_torso = 0;
    index_vertex_torso < length_vertices_torso;
    ++index_vertex_torso
  ) {
    unsigned int index_segment_torso = (
      index_vertex_torso /
      length_segments_waist_radial
    );

    unsigned int index_segment_radial_torso = (
      index_vertex_torso %
      length_segments_waist_radial
    );

    float percentage_segment_torso = (
      (float) index_segment_torso /
      (float) (
        length_segments_waist -
        1
      )
    );

    float percentage_segment_radial_torso = (
      (float) index_segment_radial_torso /
      (float) (
        length_segments_waist_radial -
        1
      )
    );

    float curve_waist = (
      math_c_sine(
        (
          percentage_segment_torso *
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
          curve_waist
        )
      ) +
      (
        radius_waist *
        curve_waist
      )
    );

    float angle = (
      percentage_segment_radial_torso *
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
      offset_height +
      (
        percentage_segment_torso *
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

    float curvature_spine = (
      0.1f
    );

    metil_mesh_zoe_body->vertices[
      index_vertex
    ].z = (
      metil_mesh_zoe_body->vertices[
        index_vertex
      ].z +
      (
        math_c_sine(
          (
            percentage_segment_torso *
            math_c_pi
          ),
          math_c_pi
        ) *
        curvature_spine *
        radius_waist
      )
    );

    float percentage_torso_width = (
      (
        metil_mesh_zoe_body->vertices[
          index_vertex
        ].x +
        radius
      ) /
      (
        radius *
        2.0f
      )
    );

    if (
      metil_mesh_zoe_body->vertices[
        index_vertex
      ].z >= 0.0f &&
      percentage_segment_torso <= 0.6f
    ) {
      float radius_stomach = (
        0.125f
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].z = (
        metil_mesh_zoe_body->vertices[
          index_vertex
        ].z +
        (
          math_c_sine(
            (
              percentage_torso_width *
              math_c_pi
            ),
            math_c_pi
          ) *
            math_c_sine(
              (
                (
                  (
                    math_c_sine(
                      (
                        (
                          percentage_segment_torso /
                          0.6f
                        ) *
                        math_c_pi_half
                      ),
                      math_c_pi
                    )
                  )
                ) *
                math_c_pi
              ),
              math_c_pi
          ) *
          radius_stomach
        )
      );
    }

    if (
      metil_mesh_zoe_body->vertices[
        index_vertex
      ].z >= 0.0f &&
      percentage_segment_torso >= 0.65f
    ) {
      float radius_breast = (
        0.5f
      );

      float radius_breast_value = (
        math_c_sine(
          math_c_sine(
            (
              math_c_sine(
                (
                  (
                    percentage_segment_torso -
                    0.65f
                  ) / 0.35f *
                  math_c_pi_half
                ),
                math_c_pi
              ) *
              math_c_pi
            ),
            math_c_pi
          ),
          math_c_pi
        ) *
        radius_breast
      );

      float percentage_segment_breast = (
        (
          percentage_segment_torso -
          0.65f
        ) /
        0.35f
      );

      if (
        percentage_segment_breast <= 0.25f
      ) {
        radius_breast_value = (
          radius_breast_value *
          (
            1.0f -
            (
              0.25f -
              percentage_segment_breast
            ) *
            3.0f
          )
        );
      }

      float percentage_breast_width = (
        percentage_torso_width
      );

      if (
        percentage_breast_width > 0.5f
      ) {
        percentage_breast_width = (
          0.5f -
          (
            percentage_breast_width -
            0.5f
          )
        );
      }

      percentage_breast_width = (
        1.0f -
        (
          percentage_breast_width /
          0.5f
        )
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].z = (
        metil_mesh_zoe_body->vertices[
          index_vertex
        ].z +
        (
          (
            math_c_sine(
              (
                percentage_breast_width *
                math_c_pi_half
              ),
              math_c_pi
            ) *
            0.75f +
            math_c_sine(
              (
                math_c_sine(
                  (
                    (1.0f - percentage_breast_width) *
                    math_c_pi_half
                  ),
                  math_c_pi
                ) *
                math_c_pi
              ),
              math_c_pi
            ) *
            0.25f
          ) *
          radius_breast_value
        )
      );
    }

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

  offset_height = (
    offset_height +
    length_torso
  );

  for (
    unsigned int index_arm = 0;
    index_arm < 2;
    ++index_arm
  ) {
    for (
      unsigned int index_vertex_shoulder = 0;
      index_vertex_shoulder < length_vertices_shoulder;
      ++index_vertex_shoulder
    ) {
      unsigned int index_segment_shoulder = (
        index_vertex_shoulder /
        length_segments_shoulder_radial
      );

      unsigned int index_segment_shoulder_radial = (
        index_vertex_shoulder %
        length_segments_shoulder_radial
      );

      float percentage_segment_shoulder_radial = (
        (float) index_segment_shoulder_radial /
        (float) (
          length_segments_shoulder_radial -
          1
        )
      );

      float percentage_segment_shoulder = (
        (float) index_segment_shoulder /
        (float) (
          length_segments_shoulder -
          1
        )
      );

      float angle = (
        percentage_segment_shoulder_radial *
        math_c_pi_doubled
      );

      float radius_x;
      float radius_z;

      if (
        percentage_segment_shoulder_radial >= 0.5f
      ) {
        radius_x = (
          radius_shoulder
        );

        radius_z = (
          math_c_sine(
            (
              math_c_sine(
                (
                  math_c_sine(
                    (
                      (
                        1.0f -
                        percentage_segment_shoulder
                      ) *
                      math_c_pi_half
                    ),
                    math_c_pi
                  ) *
                  math_c_pi_half
                ),
                math_c_pi
              ) *
              math_c_pi_half
            ),
            math_c_pi
          ) *
          radius_shoulder
        );
      } else {
        radius_x = (
          math_c_sine(
            (
              math_c_sine(
                (
                  (
                    1.0f -
                    percentage_segment_shoulder
                  ) *
                  math_c_pi_half
                ),
                math_c_pi
              ) *
              math_c_pi_half
            ),
            math_c_pi
          ) *
          radius_shoulder
        );

        radius_z = (
          math_c_sine(
            (
              math_c_sine(
                (
                  math_c_sine(
                    (
                      (
                        1.0f -
                        percentage_segment_shoulder
                      ) *
                      math_c_pi_half
                    ),
                    math_c_pi
                  ) *
                  math_c_pi_half
                ),
                math_c_pi
              ) *
              math_c_pi_half
            ),
            math_c_pi
          ) *
          radius_shoulder
        );
      }

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].x = (
        radius_hips +
        math_c_sine(
          angle,
          math_c_pi
        ) *
        radius_x +
        radius_upperarm
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].y = (
        offset_height +
        (
          length_shoulder *
          percentage_segment_shoulder
        ) -
        (
          radius_shoulder /
          4.0f
        )
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].z = (
        math_c_cosine(
          angle,
          math_c_pi
        ) *
        radius_z
      );

      if (
        percentage_segment_shoulder_radial > 0.5f
      ) {
        float percentage_shoulder_width_half = (
          percentage_segment_shoulder_radial -
          0.5f
        );

        if (
          percentage_shoulder_width_half > 0.25f
        ) {
          percentage_shoulder_width_half = (
            0.25f -
            (
              percentage_shoulder_width_half -
              0.25f
            )
          );
        }

        percentage_shoulder_width_half = (
          percentage_shoulder_width_half /
          0.25f
        );

        float additive_shoulder_z_smoothed = (
          math_c_sine(
            (
              (
                1.0f -
                (
                  percentage_segment_shoulder *
                  0.75f
                )
              ) *
              (
                percentage_shoulder_width_half
              ) *
              math_c_sine(
                (
                  percentage_segment_shoulder
                ),
                math_c_pi
              ) *
              math_c_pi_half
            ),
            math_c_pi
          ) *
          (
            radius_shoulder -
            math_c_absolute_float(
              metil_mesh_zoe_body->vertices[
                index_vertex
              ].z
            )
          ) /
          2.0f
        );

        if (
          metil_mesh_zoe_body->vertices[
            index_vertex
          ].z >= 0.0f
        ) {
          metil_mesh_zoe_body->vertices[
            index_vertex
          ].z = (
            metil_mesh_zoe_body->vertices[
              index_vertex
            ].z +
            additive_shoulder_z_smoothed
          );
        } else {
          metil_mesh_zoe_body->vertices[
            index_vertex
          ].z = (
            metil_mesh_zoe_body->vertices[
              index_vertex
            ].z -
            additive_shoulder_z_smoothed
          );
        }
      }

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].w = (
        1.0f
      );

      if (
        index_arm == 0
      ) {
        metil_mesh_zoe_body->vertices[
          index_vertex
        ].x = -(
          metil_mesh_zoe_body->vertices[
            index_vertex
          ].x
        );
      }

      index_vertex = (
        index_vertex +
        1
      );
    }

    for (
      unsigned int index_vertex_upper_arm = 0;
      index_vertex_upper_arm < length_vertices_upper_arm;
      ++index_vertex_upper_arm
    ) {
      unsigned int index_segment_upper_arm = (
        index_vertex_upper_arm /
        length_segments_upper_arm_radial
      );

      unsigned int index_segment_upper_arm_radial = (
        index_vertex_upper_arm %
        length_segments_upper_arm_radial
      );

      float angle = (
        (float) index_segment_upper_arm_radial /
        (float) (
          length_segments_upper_arm_radial -
          1
        ) *
        math_c_pi_doubled
      );

      float percentage_segment_upper_arm = (
        (float) index_segment_upper_arm /
        (
          (float) (
            length_segments_upper_arm -
            1
          )
        )
      );

      float radius = (
        math_c_sine(
          (
            percentage_segment_upper_arm *
            math_c_pi_half
          ),
          math_c_pi
        )
      );

      radius = (
        (1.0f - radius) *
        radius_shoulder +
        radius *
        radius_elbow
      );

      if (
        percentage_segment_upper_arm <= 0.9f
      ) {
        radius = (
          math_c_sine(
            (
              (
                percentage_segment_upper_arm /
                0.9f
              ) *
              math_c_pi
            ),
            math_c_pi
          ) *
          (
            radius_upperarm -
            radius
          ) +
          radius
        );
      }

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].x = (
        radius_hips +
        math_c_sine(
          angle,
          math_c_pi
        ) *
        radius +
        radius_upperarm
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].y = (
        offset_height -
        (
          length_upper_arm *
          percentage_segment_upper_arm
        ) -
        (
          radius_shoulder /
          4.0f
        )
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
        index_arm == 0
      ) {
        metil_mesh_zoe_body->vertices[
          index_vertex
        ].x = -(
          metil_mesh_zoe_body->vertices[
            index_vertex
          ].x
        );
      }

      index_vertex = (
        index_vertex +
        1
      );
    }

    for (
      unsigned int index_vertex_forearm = 0;
      index_vertex_forearm < length_vertices_forearm;
      ++index_vertex_forearm
    ) {
      unsigned int index_segment_forearm = (
        index_vertex_forearm /
        length_segments_forearm_radial
      );

      unsigned int index_segment_forearm_radial = (
        index_vertex_forearm %
        length_segments_forearm_radial
      );

      float angle = (
        (float) index_segment_forearm_radial /
        (
          (float) length_segments_forearm_radial -
          1
        ) *
        math_c_pi_doubled
      );

      float percentage_segment_forearm = (
        (float) index_segment_forearm /
        (
          (float) length_segments_forearm -
          1
        )
      );

      float radius = (
        math_c_sine(
          (
            percentage_segment_forearm *
            math_c_pi_half
          ),
          math_c_pi
        )
      );

      radius = (
        (1.0f - radius) *
        radius_elbow +
        radius *
        radius_wrist
      );

      float percentage_segment_forearm_smoothed = (
        math_c_sine(
          (
            math_c_sine(
              (
                percentage_segment_forearm *
                math_c_pi_half
              ),
              math_c_pi
            ) *
            math_c_pi_half
          ),
          math_c_pi
        )
      );

      if (
        percentage_segment_forearm_smoothed <= 0.5f
      ) {
        radius = (
          math_c_sine(
            (
              percentage_segment_forearm_smoothed *
              math_c_pi
            ),
            math_c_pi
          ) *
          (
            radius_forearm -
            radius
          ) +
          (
            radius
          )
        );
      } else {
        radius = (
          math_c_sine(
            (
              math_c_sine(
                (
                  percentage_segment_forearm_smoothed *
                  math_c_pi
                ),
                math_c_pi
              ) *
              math_c_pi_half
            ),
            math_c_pi
          ) *
          (
            radius_forearm -
            radius
          ) +
          (
            radius
          )
        );
      }

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].x = (
        radius_hips +
        radius_upperarm +
        math_c_sine(
          angle,
          math_c_pi
        ) *
        radius
      );

      metil_mesh_zoe_body->vertices[
        index_vertex
      ].y = (
        offset_height -
        length_upper_arm -
        (
          length_forearm *
          percentage_segment_forearm
        ) -
        (
          radius_shoulder /
          4.0f
        )
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
        index_arm == 0
      ) {
        metil_mesh_zoe_body->vertices[
          index_vertex
        ].x = -(
          metil_mesh_zoe_body->vertices[
            index_vertex
          ].x
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
      (unsigned int)
      (
        index_indices /
        3 +
        (
          (
            (
              index_indices %
              0x03
            ) <
            0x02
          )
          ? (
            index_indices %
            0x03
          )
          : (
            length_segments_default *
            multiplier_vertex
          )
        )
      ) %
      metil_mesh_zoe_body->length_vertices
    );
  }
}
