#include <textures/zoe_texture_static.h>

#include <clic3_memory.h>

#include <math_c_absolute.h>
#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>
#include <math_c_vector_distance.h>

#include <metil_group.h>
#include <metil_image/metil_image_offsets.h>
#include <metil_object/metil_object.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

id<MTLTexture> zoe_texture_hill_lighting_generate(
  struct metil_group* metil_group_mushrooms,
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
    1332
  );

  texture_descriptor.height = (
    2000
  );

  static id<MTLTexture> texture;

  texture = [
    metal_device
    newTextureWithDescriptor: texture_descriptor
  ];

  MTLRegion region = {
    {0x00, 0x00, 0x00},
    {texture_descriptor.width, texture_descriptor.height, 0x01}
  };

  unsigned int length_bytes_texture_row = (
    0x04 *
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

  unsigned char minimum_brightness = (
    0x01
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
        0x04 +
        index_y *
        texture_descriptor.width *
        0x04
      );

      pixel_bytes[
        index_pixel +
        metil_image_offset_rgba_8_r
      ] = (
        minimum_brightness
      );

      pixel_bytes[
        index_pixel +
        metil_image_offset_rgba_8_g
      ] = (
        minimum_brightness
      );

      pixel_bytes[
        index_pixel +
        metil_image_offset_rgba_8_b
      ] = (
        minimum_brightness
      );

      pixel_bytes[
        index_pixel +
        metil_image_offset_rgba_8_a
      ] = (
        0xff
      );
    }
  }

  signed char distance_light = (
    0x16
  );

  float maximum_distance_lighting = (
    distance_light *
    0x02
  );

  for (
    unsigned short int index_mushroom = (
      0x00
    );
    (
      index_mushroom <
      metil_group_mushrooms->length
    );
    ++index_mushroom
  ) {
    struct metil_object* metil_object_mushroom = (
      metil_group_mushrooms->renderables[
        index_mushroom
      ]->renderable
    );

    for (
      signed char offset_x = -distance_light;
      offset_x <= distance_light;
      ++offset_x
    ) {
      unsigned int offset_pixel_x = (
        (unsigned int)
        (
          (
            1332.0f +
            metil_object_mushroom->position.x
          ) /
          2664.0f *
          texture_descriptor.width +
          offset_x
        ) *
        0x04
      );

      for (
        signed char offset_y = -distance_light;
        offset_y <= distance_light;
        ++offset_y
      ) {
        unsigned int index_pixel = (
          offset_pixel_x +
          (unsigned int)
          (
            (
              (
                2000.0f +
                metil_object_mushroom->position.z
              ) /
              4000.0f
            ) *
            texture_descriptor.height +
            offset_y
          ) *
          texture_descriptor.width *
          0x04
        );

        unsigned char value = (
          (
            1.0f -
           // math_c_sine(
              math_c_sine(
                (                  math_c_sine(
                    (
                      (                        (float)
                        (
                          math_c_absolute_char(
                            offset_y
                          ) +
                          math_c_absolute_char(
                            offset_x
                          )
                        ) /
                        maximum_distance_lighting
                      ) *
                      math_c_pi_half
                    ),
                    math_c_pi
                  ) *
                  math_c_pi_half
                ),
                math_c_pi
            )
          ) *
          0xff
        );

        if (
          (
            pixel_bytes[
              index_pixel
            ] +
            value
          ) >=
          0xff
        ) {
          pixel_bytes[
            index_pixel +
            metil_image_offset_rgba_8_r
          ] = (
            0xff
          );

          pixel_bytes[
            index_pixel +
            metil_image_offset_rgba_8_g
          ] = (
            0xff
          );

          pixel_bytes[
            index_pixel +
            metil_image_offset_rgba_8_b
          ] = (
            0xff
          );
        } else {
          pixel_bytes[            index_pixel +
            metil_image_offset_rgba_8_r
          ] = (
            pixel_bytes[
              index_pixel +
              metil_image_offset_rgba_8_r
            ] +
            value
          );

          pixel_bytes[
            index_pixel +
            metil_image_offset_rgba_8_g
          ] = (
            pixel_bytes[
              index_pixel +
              metil_image_offset_rgba_8_g
            ] +
            value
          );

          pixel_bytes[
            index_pixel +
            metil_image_offset_rgba_8_b
          ] = (
            pixel_bytes[
              index_pixel +
              metil_image_offset_rgba_8_b
            ] +
            value
          );
        }
      }
    }
  }

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
