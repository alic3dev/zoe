#include <utilities/time.h>

#include <sys/time.h>

unsigned long int time_milliseconds_get() {
  struct timeval timeval;

  gettimeofday(
    &timeval,
    (void*)0
  );

  return time_microseconds_to_milliseconds(
    time_seconds_to_microseconds(timeval.tv_sec) + timeval.tv_usec
  );
}
