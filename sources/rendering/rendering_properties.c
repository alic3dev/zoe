#include <rendering/rendering_properties.h>

#include <rendering/camera/camera.h>

#include <pthread.h>

void rendering_properties_initialize(
  struct rendering_properties* rendering_properties
) {
  pthread_mutex_init(
    &rendering_properties->mutex_frame,
    (void*)0
  );

  rendering_properties->count_completed_frames = (
    count_max_frames
  );

  camera_initialize(
    &rendering_properties->camera
  );
}

void rendering_properties_destory(
  struct rendering_properties* rendering_properties
) {
  pthread_mutex_destroy(
    &rendering_properties->mutex_frame
  );
}
