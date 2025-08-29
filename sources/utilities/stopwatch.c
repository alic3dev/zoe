#include <utilities/stopwatch.h>
#include <utilities/time.h>

#include <sys/time.h>

void stopwatch_start(
  struct stopwatch* stopwatch
) {
  gettimeofday(
    &stopwatch->timeval,
    (void*)0
  );
}

unsigned long int stopwatch_elapsed(
  struct stopwatch* stopwatch
) {
  struct timeval timeval_current;

  gettimeofday(
    &timeval_current,
    (void*)0
  );

  return time_microseconds_to_milliseconds(
    (time_seconds_to_microseconds(timeval_current.tv_sec) + timeval_current.tv_usec) -
    (time_seconds_to_microseconds(stopwatch->timeval.tv_sec) + stopwatch->timeval.tv_usec)
  );
}
