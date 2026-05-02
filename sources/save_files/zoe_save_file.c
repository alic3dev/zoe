#include <save_files/zoe_save_file.h>

#include <data/data_player.h>
#include <save_files/zoe_save_files.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <metil_debug/metil_debug_log.h>

#include <stdio.h>

#define bytes_save(value,type)\
  clic3_bytes_copy(\
    (\
      bytes_save_file +\
      offset_byte\
    ),\
    value,\
    sizeof(\
      type\
    )\
  );\
  \
  offset_byte = (\
    offset_byte +\
    sizeof(\
      type\
    )\
  );

#define bytes_read(value,type)\
  if (\
    (\
      ftell(\
        file_save_file\
      ) +\
      sizeof(\
        type\
      )\
    ) <\
    length_bytes_save_file\
  ) {\
    fread(\
      value,\
      sizeof(\
        type\
      ),\
      0x00,\
      file_save_file\
    );\
  }\

unsigned char zoe_save_file_save(
  struct zoe_save_files* zoe_save_files,
  struct zoe_data_player* zoe_data_player,
  unsigned char index_save_file
) {
  if (
    (
      index_save_file >=
      zoe_save_files_length_save_files
    ) ||
    (
      zoe_save_files->path_save_file[
        index_save_file
      ] ==
      0x00
    )
  ) {
    metil_debug_log(
      metil_debug_log_level_error,
      zoe_save_file_debug_log_save_file_inaccessable
    );

    return (
      0x01
    );
  }

  FILE* file_save_file = (
    fopen(
      zoe_save_files->path_save_file[
        index_save_file
      ],
      "wb"
    )
  );

  if (
    file_save_file ==
    0x00
  ) {
    metil_debug_log(
      metil_debug_log_level_error,
      zoe_save_file_debug_log_save_file_open_failure
    );

    return (
      0x01
    );
  }

  unsigned short int length_bytes_save_file = (
    sizeof(
      unsigned short int
    ) *
    (
      0x06 +
      zoe_data_player->inventory.length_items
    ) +
    sizeof(
      enum zoe_inventory_item_type
    ) *
    zoe_data_player->inventory.length_items +
    0x02
  );

  unsigned char* bytes_save_file = (
    clic3_memory_allocate_raw(
      length_bytes_save_file
    )
  );

  unsigned short int offset_byte = (
    0x00
  );

  unsigned short int id_null = (
    0x00
  );

  bytes_save(
    &zoe_data_player->health,
    unsigned short int
  );

  bytes_save(
    &zoe_data_player->health_maximum,
    unsigned short int
  );

  if (
    zoe_data_player->item_primary !=
    0x00
  ) {
    struct zoe_item* zoe_item_primary = (
      zoe_data_player->item_primary->item
    );

    bytes_save(
      &zoe_item_primary->id,
      unsigned short int
    );
  } else {
    bytes_save(
      &id_null,
      unsigned short int
    );
  }

  if (
    zoe_data_player->item_secondary !=
    0x00
  ) {
    struct zoe_item* zoe_item_secondary = (
      zoe_data_player->item_secondary->item
    );

    bytes_save(
      &zoe_item_secondary->id,
      unsigned short int
    );
  } else {
    bytes_save(
      &id_null,
      unsigned short int
    );
  }

  if (
    zoe_data_player->weapon_primary !=
    0x00
  ) {
    struct zoe_weapon* zoe_weapon_primary = (
      zoe_data_player->weapon_primary->item
    );

    bytes_save(
      &zoe_weapon_primary->id,
      unsigned short int
    );
  } else {
    bytes_save(
      &id_null,
      unsigned short int
    );
  }

  if (
    zoe_data_player->weapon_secondary !=
    0x00
  ) {
    struct zoe_weapon* zoe_weapon_secondary = (
      zoe_data_player->weapon_secondary->item
    );

    bytes_save(
      &zoe_weapon_secondary->id,
      unsigned short int
    );
  } else {
    bytes_save(
      &id_null,
      unsigned short int
    );
  }

  bytes_save(
    &zoe_data_player->inventory.length_items,
    unsigned char
  );

  bytes_save(
    &zoe_data_player->inventory.length_maximum_items,
    unsigned char
  );

  for (
    unsigned char index_item = (
      0x00
    );
    (
      index_item <
      zoe_data_player->inventory.length_items
    );
    ++index_item
  ) {
    bytes_save(
      &zoe_data_player->inventory.items[
        index_item
      ]->type,
      enum zoe_inventory_item_type
    );

    switch (
      zoe_data_player->inventory.items[
        index_item
      ]->type
    ) {
      case zoe_inventory_item_type_item: {
        struct zoe_item* zoe_item = (
          zoe_data_player->inventory.items[
            index_item
          ]->item
        );

        bytes_save(
          &zoe_item->id,
          unsigned short int
        );

        break;
      }
      case zoe_inventory_item_type_weapon: {
        struct zoe_weapon* zoe_weapon = (
          zoe_data_player->inventory.items[
            index_item
          ]->item
        );

        bytes_save(
          &zoe_weapon->id,
          unsigned short int
        );

        break;
      }
    }
  }

  fwrite(
    bytes_save_file,
    length_bytes_save_file,
    0x01,
    file_save_file
  );

  clic3_memory_free(
    bytes_save_file
  );

  fclose(
    file_save_file
  );

  return (
    0x00
  );
}

unsigned char zoe_save_file_load(
  struct zoe_save_files* zoe_save_files,
  struct zoe_data_player* zoe_data_player,
  unsigned char index_save_file
) {
  if (
    (
      index_save_file >=
      zoe_save_files_length_save_files
    ) ||
    (
      zoe_save_files->path_save_file[
        index_save_file
      ] ==
      0x00
    )
  ) {
    metil_debug_log(
      metil_debug_log_level_error,
      zoe_save_file_debug_log_save_file_inaccessable
    );

    return (
      0x01
    );
  }

  FILE* file_save_file = (
    fopen(
      zoe_save_files->path_save_file[
        index_save_file
      ],
      "rb"
    )
  );

  if (
    file_save_file ==
    0x00
  ) {
    metil_debug_log(
      metil_debug_log_level_error,
      zoe_save_file_debug_log_save_file_open_failure
    );

    return (
      0x01
    );
  }

  fseek(
    file_save_file,
    0x00,
    SEEK_END
  );

  unsigned int length_bytes_save_file = (
    ftell(
      file_save_file
    )
  );

  rewind(
    file_save_file
  );

  bytes_read(    &zoe_data_player->health,
    unsigned short int
  );

  bytes_read(
    &zoe_data_player->health_maximum,
    unsigned short int
  )

  fclose(
    file_save_file
  );

  return (
    0x00
  );
}
