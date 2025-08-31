#ifndef __text_text_h
#define __text_text_h

#include <clic3_vector.h>

#include <CoreText/CoreText.h>

extern CTFontRef font_reference_monospace;

struct text_image {
  unsigned char* data;
  struct clic3_vector2_unsigned_int size;
};

void text_initialize();

CGGlyph* text_glyphs_encode(
  char*,
  unsigned int,
  CTFontRef
);

struct text_image* text_render(
  char*,
  CTFontRef
);

void text_destroy();

#endif
