#include <audio/io_proc_data.h>

#include <clic3_memory.h>

#include <rand_initialize.h>
#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>
#include <rand_source_type.h>

struct io_proc_data* io_proc_data_create(
  unsigned int length,
  unsigned char set
) {
  static struct io_proc_data* io_proc_data;

  io_proc_data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct io_proc_data
      )
    )
  );

  rand_initialize(
    &io_proc_data->rand_parameters,
    &io_proc_data->rand_result,
    &io_proc_data->rand_source,
    length,
    rand_mode_bytes,
    rand_source_type_divisive
  );

  struct rand_source_divisive_data* rand_source_divisive_data = (
    io_proc_data->rand_source.data
  );

  switch (
    set
  ) {
    case 0x03: {
      break;
    }
    default: {
      break;
    }
  }

  io_proc_data->destroy = (
    0x00
  );

  return (
    io_proc_data
  );
}
