#include <model/model_player.h>

#include <mesh/mesh_player.h>
#include <mesh/mesh_player_arm.h>
#include <mesh/mesh_player_head.h>
#include <mesh/mesh_player_leg.h>
#include <mesh/mesh_player_mirror.h>
#include <zoe_pipeline_index.h>

#include <math_c_minimum.h>
#include <math_c_vector.h>

#include <metil.h>
#include <metil_model/metil_model.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_camera/metil_camera.h>
#include <metil_scenes/metil_scene_controller.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void zoe_model_player_initialize(
  struct metil* metil,
  struct metil_model* metil_model,
  id<MTLTexture> texture,
  unsigned char mirror
) {
  metil_model_objects_add_length(
    metil_model,
    6
  );

  struct metil_object* metil_object_body = &(
    metil_model->objects[
      zoe_model_player_object_index_body
    ]
  );

  struct metil_object* metil_object_head = &(
    metil_model->objects[
      zoe_model_player_object_index_head
    ]
  );

  struct metil_object* metil_object_leg_left = &(
    metil_model->objects[
      zoe_model_player_object_index_leg_left
    ]
  );

  struct metil_object* metil_object_leg_right = &(
    metil_model->objects[
      zoe_model_player_object_index_leg_right
    ]
  );

  struct metil_object* metil_object_arm_left = &(
    metil_model->objects[
      zoe_model_player_object_index_arm_left
    ]
  );

  struct metil_object* metil_object_arm_right = &(
    metil_model->objects[
      zoe_model_player_object_index_arm_right
    ]
  );
  
  metil_model->positioning = (
    metil_positioning_player
  );

  if (
    mirror == 1
  ) {
    mesh_player_mirror_initialize(
      &metil_object_body->mesh
    );

    metil_model->poll = (
      zoe_model_player_mirror_poll
    );
  } else {
    mesh_player_initialize(
      &metil_object_body->mesh
    );

    metil_model->poll = (
      zoe_model_player_poll
    );
  }

  mesh_player_head_initialize(
    &metil_object_head->mesh
  );

  mesh_player_leg_initialize(
    &metil_object_leg_left->mesh
  );

  mesh_player_leg_initialize(
    &metil_object_leg_right->mesh
  );

  mesh_player_arm_initialize(
    &metil_object_arm_left->mesh,
    metil_direction_left
  );

  mesh_player_arm_initialize(
    &metil_object_arm_right->mesh,
    metil_direction_right
  );

  metil_object_body->position.y = (
    math_c_minimum_float(
      metil_object_leg_left->mesh.size.y,
      metil_object_leg_right->mesh.size.y
    )
  );

  metil_object_arm_left->position.x = -(
    metil_object_body->mesh.size.x
    / 2.0f -
    metil_object_arm_left->mesh.size.x /
    20.0f
  );

  metil_object_arm_left->position.y = (
    metil_object_body->position.y +
    metil_object_body->mesh.size.y /
    1.5f -
    metil_object_arm_left->mesh.size.y /
    2.0f
  );

  metil_object_arm_right->position.x = -(
    metil_object_arm_left->position.x
  );

  metil_object_arm_right->position.y = (
    metil_object_arm_left->position.y
  );

  metil_object_head->position.y = (
    metil_object_body->position.y +
    metil_object_body->mesh.size.y +
    metil_object_head->mesh.size.y / 4.0f
  );

  metil_object_leg_left->position.y = (
    metil_object_leg_left->mesh.size.y /
    2.0f
  );
  metil_object_leg_right->position.y = (
    metil_object_leg_right->mesh.size.y /
    2.0f
  );

  metil_object_leg_left->position.x = -1.0f;
  metil_object_leg_right->position.x = 1.0f;

  metil_object_arm_left->index_pipeline_render = (
    zoe_pipeline_index_player_arm
  );

  metil_object_arm_right->index_pipeline_render = (
    zoe_pipeline_index_player_arm
  );

  metil_object_body->index_pipeline_render = (
    zoe_pipeline_index_player_body
  );

  metil_object_head->index_pipeline_render = (
    zoe_pipeline_index_player_head
  );

  metil_object_leg_left->index_pipeline_render = (
    zoe_pipeline_index_player_leg
  );

  metil_object_leg_right->index_pipeline_render = (
    zoe_pipeline_index_player_leg
  );

  metil_model_joints_add_length(
    metil_model,
    4
  );

  metil_model_vertex_joint_maps_initialize(
    metil_model
  );

  struct metil_joint* metil_joint_player_shoulder_left = &(
    metil_model->joints[
      zoe_model_player_joint_index_shoulder_left
    ]
  );

  struct metil_joint* metil_joint_player_shoulder_right = &(
    metil_model->joints[
      zoe_model_player_joint_index_shoulder_right
    ]
  );

  struct metil_joint* metil_joint_player_elbow_left = &(
    metil_model->joints[
      zoe_model_player_joint_index_elbow_left
    ]
  );

  struct metil_joint* metil_joint_player_elbow_right = &(
    metil_model->joints[
      zoe_model_player_joint_index_elbow_right
    ]
  );

  metil_joint_attach(
    metil_joint_player_shoulder_left,
    metil_joint_player_elbow_left
  );

  metil_joint_attach(
    metil_joint_player_shoulder_right,
    metil_joint_player_elbow_right
  );

  metil_joint_player_elbow_left->position.x = (
    metil_object_arm_left->position.x
  );

  metil_joint_player_elbow_left->position.y = (
    metil_object_arm_left->position.y
  );

  metil_joint_player_elbow_left->position.z = (
    metil_object_arm_left->position.z
  );

  metil_joint_player_elbow_right->position.x = (
    metil_object_arm_right->position.x
  );

  metil_joint_player_elbow_right->position.y = (
    metil_object_arm_right->position.y
  );

  metil_joint_player_elbow_right->position.z = (
    metil_object_arm_right->position.z
  );

  metil_joint_player_shoulder_left->position.x = (
    metil_object_arm_left->position.x +
    metil_object_arm_left->mesh.size.x /
    2.0f
  );

  metil_joint_player_shoulder_left->position.y = (
    metil_object_arm_left->position.y
  );

  metil_joint_player_shoulder_left->position.z = (
    metil_object_arm_left->position.z
  );

  metil_joint_player_shoulder_right->position.x = (
    metil_object_arm_right->position.x -
    metil_object_arm_right->mesh.size.x /
    2.0f
  );

  metil_joint_player_shoulder_right->position.y = (
    metil_object_arm_right->position.y
  );

  metil_joint_player_shoulder_right->position.z = (
    metil_object_arm_right->position.z
  );


  for (
    unsigned int index_vertex = 0;
    index_vertex < metil_object_arm_left->mesh.length_vertices;
    ++index_vertex
  ) {
    if (
      index_vertex < (
        metil_object_arm_left->mesh.length_vertices /
        2.0f
      )
    ) {
      metil_model_vertex_joint_attach(
        metil_model,
        zoe_model_player_object_index_arm_left,
        index_vertex,
        zoe_model_player_joint_index_shoulder_left
      );
    } else {
      metil_model_vertex_joint_attach(
        metil_model,
        zoe_model_player_object_index_arm_left,
        index_vertex,
        zoe_model_player_joint_index_elbow_left
      );
    }
  }

  for (
    unsigned int index_vertex = 0;
    index_vertex < metil_object_arm_right->mesh.length_vertices;
    ++index_vertex
  ) {
    if (
      index_vertex < (
        metil_object_arm_right->mesh.length_vertices /
        2.0f
      )
    ) {
      metil_model_vertex_joint_attach(
        metil_model,
        zoe_model_player_object_index_arm_right,
        index_vertex,
        zoe_model_player_joint_index_shoulder_right
      );
    } else {
      metil_model_vertex_joint_attach(
        metil_model,
        zoe_model_player_object_index_arm_right,
        index_vertex,
        zoe_model_player_joint_index_elbow_right
      );
    }
  }

  metil_model_buffers_initialize(
    metil,
    metil_model,
    metil->renderer_interface.metal_device
  );

  metil_model_texture_add(
    metil_model,
    texture
  );
}

void zoe_model_player_poll(
  struct metil* metil,
  struct metil_model* metil_model,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct metil_scene_controller* scene_controller = (
    metil->scene_controller
  );

  metil_model->rotation.y = (
    -scene_controller->scene.player.rotation.y
  );

  metil_model->position.x = (
    scene_controller->scene.player.position.x
  );

  metil_model->position.y = (
    scene_controller->scene.player.position.y
  );

  metil_model->position.z = (
    scene_controller->scene.player.position.z
  );

  struct metil_joint* metil_joint_player_shoulder_left = &(
    metil_model->joints[
      zoe_model_player_joint_index_shoulder_left
    ]
  );

  struct metil_joint* metil_joint_player_shoulder_right = &(
    metil_model->joints[
      zoe_model_player_joint_index_shoulder_right
    ]
  );

  struct metil_joint* metil_joint_player_elbow_left = &(
    metil_model->joints[
      zoe_model_player_joint_index_elbow_left
    ]
  );

  struct metil_joint* metil_joint_player_elbow_right = &(
    metil_model->joints[
      zoe_model_player_joint_index_elbow_right
    ]
  );

  unsigned long int time = (
    scene_controller->scene.time
  );

  float position_time = (
    (int) (time % 2000) - 1000
  ) / 1000.0f;

  unsigned char flip = (
    (time / 2000) % 2
  );

  float movement = 0.5f;

  float position_time_movement = (
    position_time *
    movement
  );

  if (
    flip == 1
  ) {
    position_time_movement = (
      -position_time_movement
    );
  }

  float rotation_shoulder_y = (
    position_time_movement *
    0.05f
  );

  float rotation_shoulder_z = (
    position_time_movement *
    0.1f
  );

  float rotation_elbow_y = (
    position_time_movement *
    0.05f
  );

  float rotation_elbow_z = (
    position_time_movement *
    0.1f
  );

  metil_joint_player_shoulder_left->rotation.z = (
    0.8f +
    rotation_shoulder_z
  );

  metil_joint_player_shoulder_left->rotation.y = (
    rotation_shoulder_y
  );

  metil_joint_player_elbow_left->rotation.y = (
    rotation_elbow_y
  );

  metil_joint_player_elbow_left->rotation.z = (
    rotation_elbow_z
  );

  metil_joint_player_shoulder_right->rotation.z = (
    -0.8f +
    -rotation_shoulder_z
  );

  metil_joint_player_shoulder_right->rotation.y = (
    -rotation_shoulder_y
  );

  metil_joint_player_elbow_right->rotation.y = (
    -rotation_elbow_y
  );

  metil_joint_player_elbow_right->rotation.z = (
    0.1f +
    -rotation_elbow_z
  );

  metil_joint_propagate(
    metil_joint_player_shoulder_left
  );

  metil_joint_propagate(
    metil_joint_player_shoulder_right
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

void zoe_model_player_mirror_poll(
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

  zoe_model_player_poll(
    metil,
    metil_model,
    matrix_projection_static,
    matrix_object_projection,
    matrix_player_projection,
    metil_camera
  );

  metil_model->position.x = (
    -metil_scene_controller->scene.player.position.x
  );

  metil_model->position.y = (
    metil_scene_controller->scene.player.position.y
  );

  metil_model->position.z = (
    -metil_scene_controller->scene.player.position.z
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
