#ifndef __metal_kit_shader_types_h
#define __metal_kit_shader_types_h

#include <simd/simd.h>
#include <clic3_vector.h>

#ifndef __METAL_VERSION__
#define constant
#endif

#define size_ground_min_x -200.0f
#define size_ground_min_y 0.0f
#define size_ground_min_z -200.0f

#define size_ground_max_x 200.0f
#define size_ground_max_y 10.4345f
#define size_ground_max_z 200.0f

static constant const struct clic3_vector3_float size_ground_min = {
  .x = -200.0f,
  .y = 0.0f,
  .z = -200.0f
};

static constant const struct clic3_vector3_float size_ground_max = {
  .x = 200.0f,
  .y = 10.4345f,
  .z = 200.0f
};

static constant const struct clic3_vector3_float range_ground = {
  .x = size_ground_max_x - size_ground_min_x,
  .y = size_ground_max_y - size_ground_min_y,
  .z = size_ground_max_z - size_ground_min_z
};

static constant const struct clic3_vector2_unsigned_int length_vertices_ground = {
  .x = 100,
  .y = 100
};

static constant const struct clic3_vector2_float increment_ground = {
  .x = range_ground.x / (float)(length_vertices_ground.x),
  .y = range_ground.z / (float)(length_vertices_ground.y)
};

static constant const unsigned int length_objects_x = 7;
static constant const unsigned int length_objects_y = 7;
static constant const unsigned int length_objects_z = 7;

static constant const unsigned int length_objects_xyz = (
  length_objects_x * length_objects_y * length_objects_z
) + 1;

typedef enum {
  metal_kit_vertex_input_index_positions = 0,
  metal_kit_vertex_input_index_frame_data = 1,
  metal_kit_vertex_input_index_mesh_index = 2
} metal_kit_vertex_input_index;

typedef struct {
  matrix_float4x4 view_model_matrix_projection;
  // clic3_matrix4x4_float view_model_matrix_projection;
} metal_kit_data_frame_object;

typedef struct {
  metal_kit_data_frame_object objects[length_objects_xyz];
} metal_kit_data_frame;

#endif
