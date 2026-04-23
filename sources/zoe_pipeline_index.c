#include <zoe_pipeline_index.h>

void zoe_pipeline_index_initialize(
  struct zoe_pipeline_index* zoe_pipeline_index
) {
  zoe_pipeline_index->ground         = 0x00;
  zoe_pipeline_index->hill           = 0x00;
  zoe_pipeline_index->loading_screen = 0x00;
  zoe_pipeline_index->leaf           = 0x00;
  zoe_pipeline_index->mushroom       = 0x00;
  zoe_pipeline_index->text           = 0x00;
  zoe_pipeline_index->text_backing   = 0x00;
  zoe_pipeline_index->tree           = 0x00;
  zoe_pipeline_index->zoe_body       = 0x00;
  zoe_pipeline_index->zoe_hair       = 0x00;
}
