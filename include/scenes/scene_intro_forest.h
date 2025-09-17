#ifndef __scenes_scene_intro_forest_h
#define __scenes_scene_intro_forest_h

#include <metil.h>

#include <CoreAudio/CoreAudio.h>
#include <MetalKit/MetalKit.h>

enum textures_scene_intro_forest {
  textures_scene_intro_forest_ground = 0,
  textures_scene_intro_forest_tree = 1,
  textures_scene_intro_forest_player = 2
};

void scene_intro_forest_initialize(
  struct metil_scene*,
  id<MTLDevice>
);

void scene_intro_forest_poll(
  struct metil_scene*
);

void scene_intro_forest_destroy(
  struct metil_scene*
);

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
