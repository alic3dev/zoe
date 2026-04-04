#include <data/data_zoe.h>

#include <data/data_player.h>
#include <renderables/renderables_static.h>

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
}
