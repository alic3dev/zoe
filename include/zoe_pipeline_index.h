#ifndef __zoe_pipeline_index_h
#define __zoe_pipeline_index_h

struct zoe_pipeline_index {
  unsigned short int auop;
  unsigned short int effect_attack_slice;
  unsigned short int ground;
  unsigned short int hill;
  unsigned short int loading_screen;
  unsigned short int leaf;
  unsigned short int mushroom;
  unsigned short int text;
  unsigned short int text_backing;
  unsigned short int tree;
  unsigned short int zoe_body;
  unsigned short int zoe_hair;
};

#ifndef __METAL_VERSION__
void zoe_pipeline_index_initialize(
  struct zoe_pipeline_index*
);
#endif

#endif
