#ifndef __group_text_with_backing_h
#define __group_text_with_backing_h

#include <metil.h>
#include <metil_group.h>

enum group_text_with_backing_index {
  group_text_with_backing_index_text_backing = 0x00,
  group_text_with_backing_index_text         = 0x01
};

void group_text_with_backing_initialize(
  struct metil* _Nonnull,
  struct metil_group* _Nonnull,
  char* _Nonnull
);

void group_text_with_backing_visibility_set(
  struct metil_group* _Nonnull,
  float,
  float
);

void group_text_with_backing_visibility_minimum_maximum_set(
  struct metil_group* _Nonnull,
  float,
  float,
  float
);

#endif
