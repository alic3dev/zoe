#ifndef __zoe_zoe_textures_zoe_texture_hill_lighting_h
#define __zoe_zoe_textures_zoe_texture_hill_lighting_h

#include <metil_group.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

id<MTLTexture> _Nonnull zoe_texture_hill_lighting_generate(
  struct metil_group* _Nonnull,
  id<MTLDevice> _Nonnull
);

#endif
