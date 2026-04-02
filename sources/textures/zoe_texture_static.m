#include <textures/zoe_texture_static.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

#include <metil_image/metil_image_offsets.h>

#include <rand_clean.h>
#include <rand_functions.h>
#include <rand_initialize.h>
#include <rand_parameters.h>
#include <rand_result.h>
#include <rand_source.h>
#include <rand_source_type.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

id<MTLTexture> zoe_texture_static_generate(
  struct math_c_vector2_unsigned_short_int size,
  id<MTLDevice> metal_device
) {
  MTLTextureDescriptor* texture_descriptor = [
    [
      MTLTextureDescriptor
      alloc
    ]
    init
  ];

  texture_descriptor.pixelFormat = (
    MTLPixelFormatRGBA8Unorm
  );

  texture_descriptor.width = (
    size.x
  );

  texture_descriptor.height = (
    size.y
  );

  static id<MTLTexture> texture;

  texture = [
    metal_device
    newTextureWithDescriptor: texture_descriptor
  ];

  MTLRegion region = {
    {0, 0, 0},
    {texture_descriptor.width, texture_descriptor.height, 1}
  };

  unsigned int length_bytes_texture_row = (
    4 *
    texture_descriptor.width
  );

  unsigned int length_bytes_texture = (
    length_bytes_texture_row *
    texture_descriptor.height
  );

  unsigned char* pixel_bytes = (
    clic3_memory_allocate_raw(
      length_bytes_texture
    )
  );

  struct rand_parameters rand_parameters;
  struct rand_result rand_result;
  struct rand_source rand_source;

  rand_initialize(
    &rand_parameters,
    &rand_result,
    &rand_source,
    (
      texture_descriptor.width *
      texture_descriptor.height *
      4
    ),
    rand_mode_bytes,
    rand_source_type_divisive
  );

  rand_get(
    &rand_source,
    &rand_result,
    &rand_parameters
  );

  for (
    unsigned int index_x = 0;
    index_x < texture_descriptor.width;
    ++index_x
  ) {
    for (
      unsigned int index_y = 0;
      index_y < texture_descriptor.height;
      ++index_y
    ) {
      unsigned int index_pixel = (
        index_x *
        4 +
        index_y *
        texture_descriptor.width *
        4
      );

      unsigned char coloured = (
        rand_result.bytes[
          (
            index_pixel +
            0
          ) %
          rand_result.length
        ] >= 0x20
      );

      if (
        coloured == 1
      ) {
        pixel_bytes[
          index_pixel +
          metil_image_offset_rgba_8_r
        ] = (
          rand_result.bytes[
            (
              index_pixel +
              1
            ) %
            rand_result.length
          ]
        );

        pixel_bytes[
          index_pixel +
          metil_image_offset_rgba_8_g
        ] = (
          rand_result.bytes[
            (
              index_pixel +
              2
            ) %
            rand_result.length
          ]
        );

        pixel_bytes[
          index_pixel +
          metil_image_offset_rgba_8_b
        ] = (
          rand_result.bytes[
            (
              index_pixel +
              3
            ) %
            rand_result.length
          ]
        );
      } else {
        pixel_bytes[
          index_pixel +
          metil_image_offset_rgba_8_r
        ] = (
          rand_result.bytes[
            (
              index_pixel +
              1
            ) %
            rand_result.length
          ] >= 0x80
          ? 0xff
          : 0x00
        );

        pixel_bytes[
          index_pixel +
          metil_image_offset_rgba_8_g
        ] = (
          rand_result.bytes[
            (
              index_pixel +
              1
            ) %
            rand_result.length
          ] >= 0x80
          ? 0xff
          : 0x00
        );

        pixel_bytes[
          index_pixel +
          metil_image_offset_rgba_8_b
        ] = (
          rand_result.bytes[
            (
              index_pixel +
              1
            ) %
            rand_result.length
          ] >= 0x80
          ? 0xff
          : 0x00
        );
      }

      pixel_bytes[
        index_pixel +
        metil_image_offset_rgba_8_a
      ] = (
        0xff
      );
    }
  }

  rand_clean(
    &rand_result,
    &rand_source
  );

  [
    texture
    replaceRegion: region
    mipmapLevel: 0
    withBytes: pixel_bytes
    bytesPerRow: length_bytes_texture_row
  ];

  [
    texture_descriptor
    release
  ];

  clic3_memory_free_raw(
    pixel_bytes
  );

  return (
    texture
  );
}
