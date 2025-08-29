#include <audio/audio.h>

#include <debug/log.h>

#include <cer0_audio_output.h>

#include <CoreAudio/CoreAudio.h>

struct cer0_audio_output audio_output;

void audio_initialize() {
  cer0_audio_output_initialize(
    &audio_output,
    audio_output_io_proc,
    (void*)0
  );
}

void audio_destroy() {
  unsigned char status_audio_destory = cer0_audio_output_destroy(
    &audio_output
  );

  if (status_audio_destory != 0) {
    debug_log_error("failed_to_destory_audio\n");
  }
}

OSStatus audio_output_io_proc(
  AudioObjectID id_audio_object,
  const AudioTimeStamp* time_stamp_audio,
  const AudioBufferList* list_buffer_audio_in,
  const AudioTimeStamp* time_stamp_audio_in,
  AudioBufferList* list_buffer_audio_out,
  const AudioTimeStamp* time_stamp_audio_out,
  void* data
) {
  for (
    unsigned long int index_buffer = 0;
    index_buffer < list_buffer_audio_out->mNumberBuffers;
    ++index_buffer
  ) {
    AudioBuffer audio_buffer_current = list_buffer_audio_out->mBuffers[index_buffer];

    float* buffer_out = audio_buffer_current.mData;
    unsigned long int size_buffer_out = audio_buffer_current.mDataByteSize / sizeof(float);
    unsigned long int count_channel_out = audio_buffer_current.mNumberChannels;
    
    for (
      unsigned long int index_buffer_out = 0;
      index_buffer_out < size_buffer_out;
      ++index_buffer_out
    ) {
      unsigned long int channel = index_buffer % count_channel_out;

      if (channel == 0) {
        buffer_out[index_buffer_out] = 0.0f;
      } else {
        buffer_out[index_buffer_out] = 0.0f;
      }
    }
  }

  return 0;
}
