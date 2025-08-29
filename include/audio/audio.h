#ifndef __audio_audio_h
#define __audio_audio_h

#include <cer0_audio_output.h>

#include <CoreAudio/CoreAudio.h>

extern struct cer0_audio_output audio_output;

void audio_initialize();
void audio_destroy();

OSStatus audio_output_io_proc(
  AudioObjectID,
  const AudioTimeStamp*,
  const AudioBufferList*,
  const AudioTimeStamp*,
  AudioBufferList*,
  const AudioTimeStamp*,
  void*
);

#endif
