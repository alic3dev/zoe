#ifndef __zoe_textures_zoe_texture_cicuit_h
#define __zoe_textures_zoe_texture_cicuit_h

#include <math_c_vector.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

id<MTLTexture> _Nonnull zoe_texture_static_generate(
  struct math_c_vector2_unsigned_short_int,
  id<MTLDevice> _Nonnull
);

#endif
