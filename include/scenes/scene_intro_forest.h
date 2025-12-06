#ifndef __zoe_scenes_scene_intro_forest_h
#define __zoe_scenes_scene_intro_forest_h

#include <audio/io_proc_data.h>

#include <metil.h>

#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>

#if target_os_ios
#include <AVFAudio/AVFAudio.h>
#else
#include <CoreAudio/CoreAudio.h>
#endif
#include <MetalKit/MetalKit.h>

enum textures_scene_intro_forest {
  textures_scene_intro_forest_ground = 0,
  textures_scene_intro_forest_tree = 1,
  textures_scene_intro_forest_player = 2
};

void scene_intro_forest_initialize(
  struct metil_scene* _Nonnull,
  id<MTLDevice> _Nonnull
);

void scene_intro_forest_poll(
  struct metil_scene* _Nonnull
);

void scene_intro_forest_destroy(
  struct metil_scene* _Nonnull
);

struct scene_intro_forest_data {
  struct io_proc_data* _Nonnull io_proc_data;
};

#if target_os_ios
OSStatus scene_intro_forest_io_proc(
  BOOL* _Nonnull,
  const AudioTimeStamp* _Nonnull,
  AVAudioFrameCount,
  AudioBufferList* _Nonnull,
  void* _Nonnull
);
#else
OSStatus scene_intro_forest_io_proc(
  AudioObjectID,
  const AudioTimeStamp*,
  const AudioBufferList*,
  const AudioTimeStamp*,
  AudioBufferList*,
  const AudioTimeStamp*,
  void*
);
#endif

#endif
