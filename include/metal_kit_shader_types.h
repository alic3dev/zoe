#ifndef __metal_kit_shader_types_h
#define __metal_kit_shader_types_h

#include <simd/simd.h>
#include <clic3_vector.h>

#ifndef __METAL_VERSION__
#define constant
#endif

static constant const  unsigned short int total_length_objects = 500;

enum mode_texture {
  mode_texture_default,
  mode_texture_ground
};

typedef enum {
  metal_kit_vertex_input_index_positions = 2,
  metal_kit_vertex_input_index_frame_data = 1,
  metal_kit_vertex_input_index_data = 0
} metal_kit_vertex_input_index;

typedef struct {
  matrix_float4x4 view_model_matrix_projection;
  float width;
  float height;
  float depth;
  unsigned int noise;
  unsigned int id;
  enum mode_texture mode_texture;
} metal_kit_data_frame_object;

typedef struct {
  struct clic3_vector3_float rotation_camera;
  unsigned int frame;
} metal_kit_data_frame;

#endif
