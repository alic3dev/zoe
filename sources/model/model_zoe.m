#include <model/model_zoe.h>

#include <animation/zoe/animation_zoe_idle.h>
#include <animation/zoe/animation_zoe_jumping.h>
#include <animation/zoe/animation_zoe_running.h>
#include <animation/zoe/animation_zoe_sneaking.h>
#include <animation/zoe/animation_zoe_walking.h>
#include <data/data_player.h>
#include <mesh/mesh_zoe_body.h>
#include <zoe_pipeline_index.h>

#include <clic3_memory.h>

#include <math_c_absolute.h>
#include <math_c_minimum.h>
#include <math_c_vector.h>

#include <metil.h>
#include <metil_animation/metil_animation.h>
#include <metil_model/metil_model.h>
#include <metil_player/metil_player.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_camera/metil_camera.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>


#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_model_zoe_initialize(
  struct metil* metil,
  struct metil_model* metil_model
) {
  metil_model_objects_add_length(
    metil_model,
    1
  );

  struct metil_object* metil_object_zoe_body = &(
    metil_model->objects[
      0
    ]
  );

  mesh_zoe_body_initialize(
    &metil_object_zoe_body->mesh
  );

  metil_object_zoe_body->type_primitive = (
    MTLPrimitiveTypeTriangleStrip
  );

  metil_object_zoe_body->index_pipeline_render = (
    zoe_pipeline_index_zoe_body
  );

  metil_model_joints_add_length(
    metil_model,
    zoe_model_length_joints
  );

  metil_model_vertex_joint_maps_initialize(
    metil_model
  );

  struct metil_joint* metil_joint_neck = (
    &metil_model->joints[
      zoe_model_joint_index_neck
    ]
  );

  struct metil_joint* metil_joint_shoulder_left = (
    &metil_model->joints[
      zoe_model_joint_index_shoulder_left
    ]
  );

  struct metil_joint* metil_joint_shoulder_right = (
    &metil_model->joints[
      zoe_model_joint_index_shoulder_right
    ]
  );

  struct metil_joint* metil_joint_elbow_left = (
    &metil_model->joints[
      zoe_model_joint_index_elbow_left
    ]
  );

  struct metil_joint* metil_joint_elbow_right = (
    &metil_model->joints[
      zoe_model_joint_index_elbow_right
    ]
  );

  struct metil_joint* metil_joint_wrist_left = (
    &metil_model->joints[
      zoe_model_joint_index_wrist_left
    ]
  );

  struct metil_joint* metil_joint_wrist_right = (
    &metil_model->joints[
      zoe_model_joint_index_wrist_right
    ]
  );

  struct metil_joint* metil_joint_hips = (
    &metil_model->joints[
      zoe_model_joint_index_hips
    ]
  );

  struct metil_joint* metil_joint_hip_left = (
    &metil_model->joints[
      zoe_model_joint_index_hip_left
    ]
  );

  struct metil_joint* metil_joint_hip_right = (
    &metil_model->joints[
      zoe_model_joint_index_hip_right
    ]
  );

  struct metil_joint* metil_joint_knee_left = (
    &metil_model->joints[
      zoe_model_joint_index_knee_left
    ]
  );

  struct metil_joint* metil_joint_knee_right = (
    &metil_model->joints[
      zoe_model_joint_index_knee_right
    ]
  );

  struct metil_joint* metil_joint_ankle_left = (
    &metil_model->joints[
      zoe_model_joint_index_ankle_left
    ]
  );

  struct metil_joint* metil_joint_ankle_right = (
    &metil_model->joints[
      zoe_model_joint_index_ankle_right
    ]
  );

  metil_joint_attach(
    metil_joint_neck,
    metil_joint_shoulder_left
  );
  
  metil_joint_attach(
    metil_joint_neck,
    metil_joint_shoulder_right
  );

  metil_joint_attach(
    metil_joint_shoulder_left,
    metil_joint_elbow_left
  );

  metil_joint_attach(
    metil_joint_shoulder_right,
    metil_joint_elbow_right
  );

  metil_joint_attach(
    metil_joint_elbow_left,
    metil_joint_wrist_left
  );

  metil_joint_attach(
    metil_joint_elbow_right,
    metil_joint_wrist_right
  );

  metil_joint_attach(
    metil_joint_neck,
    metil_joint_hips
  );

  metil_joint_attach(
    metil_joint_hips,
    metil_joint_hip_left
  );

  metil_joint_attach(
    metil_joint_hips,
    metil_joint_hip_right
  );

  metil_joint_attach(
    metil_joint_hip_left,
    metil_joint_knee_left
  );

  metil_joint_attach(
    metil_joint_hip_right,
    metil_joint_knee_right
  );

  metil_joint_attach(
    metil_joint_knee_left,
    metil_joint_ankle_left
  );

  metil_joint_attach(
    metil_joint_knee_right,
    metil_joint_ankle_right
  );

  unsigned char index_joint;

  for (
    unsigned long int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_zoe_body->mesh.length_vertices
    );
    ++index_vertex
  ) {
    if (
      index_vertex <
      mesh_zoe_body_index_vertex_calf_right_end
    ) {
      index_joint = (
        zoe_model_joint_index_knee_right
      );
    } else if (
      index_vertex <
      mesh_zoe_body_index_vertex_thigh_right_end
    ) {
      index_joint = (
        zoe_model_joint_index_hip_right
      );
    } else if (
      index_vertex <
      mesh_zoe_body_index_vertex_calf_left_end
    ) {
      index_joint = (
        zoe_model_joint_index_knee_left
      );
    } else if (
      index_vertex <
      mesh_zoe_body_index_vertex_thigh_left_end
    ) {
      index_joint = (
        zoe_model_joint_index_hip_left
      );
    } else if (
      index_vertex <
      mesh_zoe_body_index_vertex_torso_end
    ) {
      index_joint = (
        zoe_model_joint_index_neck
      );
    } else if (
      index_vertex <
      mesh_zoe_body_index_vertex_upper_arm_left_end
    ) {
      index_joint = (
        zoe_model_joint_index_shoulder_left
      );
    } else if (
      index_vertex <
      mesh_zoe_body_index_vertex_forearm_left_end
    ) {
      index_joint = (
        zoe_model_joint_index_elbow_left
      );
    } else if (
      index_vertex <
      mesh_zoe_body_index_vertex_upper_arm_right_end
    ) { 
      index_joint = (
        zoe_model_joint_index_shoulder_right
      );
    } else if (
      index_vertex <
      mesh_zoe_body_index_vertex_forearm_right_end
    ) {
      index_joint = (
        zoe_model_joint_index_elbow_right
      );
    } else {
      break;
    }

    metil_model_vertex_joint_attach(
      metil_model,
      0x00,
      index_vertex,
      index_joint
    );
  }

  metil_model_buffers_initialize(
    metil,
    metil_model,
    metil->renderer_interface.metal_device
  );

  metil_model->poll = (
    zoe_model_zoe_poll
  );

  metil_model->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct zoe_model_data
      )
    )
  );

  struct zoe_model_data* zoe_model_data = (
    metil_model->data
  );

  zoe_animation_zoe_idle_initialize(
    &zoe_model_data->animations[
      zoe_model_animation_index_idle
    ]
  );

  zoe_animation_zoe_sneaking_initialize(
    &zoe_model_data->animations[
      zoe_model_animation_index_sneaking
    ]
  );

  zoe_animation_zoe_walking_initialize(
    &zoe_model_data->animations[
      zoe_model_animation_index_walking
    ]
  );

  zoe_animation_zoe_running_initialize(
    &zoe_model_data->animations[
      zoe_model_animation_index_running
    ]
  );

  zoe_animation_zoe_jumping_initialize(
    &zoe_model_data->animations[
      zoe_model_animation_index_jumping
    ]
  );

  zoe_model_data->index_animation = (
    zoe_model_animation_index_none
  );
}

void zoe_model_zoe_poll(
  struct metil* metil,
  struct metil_model* metil_model,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene = (
    &metil_scene_controller->scene
  );

  struct metil_player* metil_player = (
    &metil_scene->player
  );

  struct zoe_data_player* zoe_data_player = (
    metil_player->data
  );

  struct zoe_model_data* zoe_model_data = (
    metil_model->data
  );

  unsigned char index_animation_previous = (
    zoe_model_data->index_animation
  );

  if (
    zoe_data_player->attributes &
    zoe_data_player_attributes_jumping
  ) {
    zoe_model_data->index_animation = (
      zoe_model_animation_index_jumping
    );
  } else if (    zoe_data_player->attributes &
    zoe_data_player_attributes_walking
  ) {
    if (
      zoe_data_player->attributes &
      zoe_data_player_attributes_sneaking
    ) {
      zoe_model_data->index_animation = (
        zoe_model_animation_index_sneaking
      );
    } else if (
      zoe_data_player->attributes &
      zoe_data_player_attributes_running
    ) {
      zoe_model_data->index_animation = (
        zoe_model_animation_index_running
      );
    } else {
      zoe_model_data->index_animation = (
        zoe_model_animation_index_walking
      );
    }
  } else {
    zoe_model_data->index_animation = (
      zoe_model_animation_index_none
    );
  }

  if (
    zoe_model_data->index_animation !=
    index_animation_previous
  ) {
    if (
      index_animation_previous !=
      zoe_model_animation_index_none
    ) {
      metil_animation_end(
        &zoe_model_data->animations[
          index_animation_previous
        ],
        metil_renderable_type_model,
        metil_model
      );
    }

    if (
      zoe_model_data->index_animation !=
      zoe_model_animation_index_none
    ) {
      metil_animation_start(
        &zoe_model_data->animations[
          zoe_model_data->index_animation
        ],
        metil_renderable_type_model,
        metil_model
      );
    }
  } else if (
    zoe_model_data->index_animation !=
    zoe_model_animation_index_none
  ) {
    metil_animation_poll(
      &zoe_model_data->animations[
        zoe_model_data->index_animation
      ],
      metil_renderable_type_model,
      metil_model
    );
  }

  metil_joint_propagate(
    &metil_model->joints[
      zoe_model_joint_index_neck
    ]
  );

  metil_model_poll(
    metil,
    metil_model,
    matrix_projection_static,
    matrix_object_projection,
    matrix_player_projection,
    metil_camera
  );
}
