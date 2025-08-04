#ifndef __metal_kit_shader_types_h
#define __metal_kit_shader_types_h

#include <simd/simd.h>

#ifndef __METAL_VERSION__
#define constant
#endif

static constant const unsigned int length_objects_x = 7;
static constant const unsigned int length_objects_y = 7;
static constant const unsigned int length_objects_z = 7;

static constant const unsigned int length_objects_xyz = (
  length_objects_x * length_objects_y * length_objects_z
);

typedef enum {
  metal_kit_vertex_input_index_positions = 0,
  metal_kit_vertex_input_index_frame_data = 1,
  metal_kit_vertex_input_index_mesh_index = 2
} metal_kit_vertex_input_index;

typedef struct {
  matrix_float4x4 view_model_matrix;
  matrix_float4x4 view_model_matrix_projection;
} metal_kit_data_frame_object;

typedef struct {
  metal_kit_data_frame_object objects[length_objects_xyz];
} metal_kit_data_frame;

#endif
