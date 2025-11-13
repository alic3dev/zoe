#include <audio/io_proc_data.h>

#include <rand_initialize.h>
#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>
#include <rand_source_type.h>

#include <stdlib.h>

struct io_proc_data* io_proc_data_create(
  unsigned int length
) {
  static struct io_proc_data* io_proc_data;
  io_proc_data = malloc(
    sizeof(struct io_proc_data)
  );

  rand_initialize(
    &io_proc_data->rand_parameters,
    &io_proc_data->rand_result,
    &io_proc_data->rand_source, 
    length,
    rand_mode_bytes,
    rand_source_type_divisive
  );

  io_proc_data->destroy = 0;

  return io_proc_data;
}
