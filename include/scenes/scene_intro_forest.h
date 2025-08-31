#ifndef __scenes_scene_intro_forest_h
#define __scenes_scene_intro_forest_h

#include <scenes/scene.h>

#include <CoreAudio/CoreAudio.h>
#include <MetalKit/MetalKit.h>

enum textures_scene_intro_forest {
  textures_scene_intro_forest_ground = 0,
  textures_scene_intro_forest_tree = 1
};

void scene_intro_forest_initialize(
  struct scene*,
  id<MTLDevice>
);

void scene_intro_forest_destroy(
  struct scene*
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
