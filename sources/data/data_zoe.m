#include <data/data_zoe.h>

#include <data/data_player.h>
#include <renderables/renderables_static.h>
#include <save_files/zoe_save_files.h>

#include <metil.h>

void zoe_data_zoe_initialize(
  struct metil* metil,
  struct zoe_data_zoe* zoe_data_zoe
) {
  zoe_data_player_initialize(
    &zoe_data_zoe->player
  );

  zoe_renderables_static_initialize(
    metil,
    &zoe_data_zoe->renderables_static
  );

  unsigned char status_zoe_save_files_initialize = (
    zoe_save_files_initialize(
      &zoe_data_zoe->save_files
    )
  );

  if (
    status_zoe_save_files_initialize ==
    0x00
  ) {
    zoe_save_files_load(
      &zoe_data_zoe->save_files
    );
  }
}

void zoe_data_zoe_destroy(
  struct metil* metil,
  struct zoe_data_zoe* zoe_data_zoe
) {
  zoe_data_player_destroy(
    &zoe_data_zoe->player
  );

  zoe_renderables_static_destroy(
    metil,
    &zoe_data_zoe->renderables_static
  );

  zoe_save_files_destroy(
    &zoe_data_zoe->save_files
  );
}
