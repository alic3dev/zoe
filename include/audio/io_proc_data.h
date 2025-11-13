#ifndef __io_proc_data_h
#define __io_proc_data_h

#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>

struct io_proc_data {
  struct rand_parameters rand_parameters;
  struct rand_source rand_source;
  struct rand_result rand_result;

  unsigned char destroy;
};

struct io_proc_data* io_proc_data_create(
  unsigned int
);

#endif
