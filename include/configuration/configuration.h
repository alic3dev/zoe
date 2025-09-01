#ifndef __configuration_configuration_h
#define __configuration_configuration_h

#include <configuration/configuration_audio.h>

struct configuration {
  struct configuration_audio audio;
};

extern struct configuration configuration;

void configuration_initialize();
unsigned char configuration_load();
void configuration_destroy();

#endif
