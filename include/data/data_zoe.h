#ifndef __data_data_zoe_h
#define __data_data_zoe_h

#include <data/data_player.h>
#include <renderables/renderables_static.h>
#include <save_files/zoe_save_files.h>
#include <zoe_pipeline_index.h>

#include <metil.h>

struct zoe_data_zoe {
  struct zoe_data_player player;

  struct zoe_renderables_static renderables_static;

  struct zoe_save_files save_files;

  struct zoe_pipeline_index pipeline_index;
};

void zoe_data_zoe_initialize(
  struct metil* _Nonnull,
  struct zoe_data_zoe* _Nonnull
);

void zoe_data_zoe_destroy(
  struct metil* _Nonnull,
  struct zoe_data_zoe* _Nonnull
);
#endif
