#include <configuration/configuration.h>

#include <audio/audio.h>
#include <debug/log.h>
#include <paths/paths.h>

#include <clic3_bytes.h>
#include <clic3_char_arrays.h>

#include <limits.h>
#include <stdlib.h>
#include <stdio.h>

struct configuration configuration;

void configuration_initialize() {
  configuration.audio.volume = 0.2f;
}

unsigned char configuration_load() {
  configuration_initialize();

  unsigned char status_configuration_load = 0;

  FILE* file_configuration = fopen(
    paths.file_configuration,
    "a+"
  );

  rewind(file_configuration);

  if (
    file_configuration == (void*)0
  ) {
    debug_log_error(
      "failed_to_[open|create]->{configuration}"
    );

    status_configuration_load = 1;

    return status_configuration_load;
  }

  char* buffer;
  unsigned int length_buffer = 0;

  buffer = malloc(
    sizeof(char) *
    length_buffer
  );

  while (
    feof(file_configuration) == 0 &&
    status_configuration_load == 0
  ) {
    char c = getc(file_configuration);

    if (
      length_buffer + 1 >= UINT_MAX - 1
    ) {
      debug_log_error(
        "configuration_file_contains_too_long_of_a_line"
      );

      status_configuration_load = 1;

      break;
    }

    if (
      c == EOF ||
      c == '\n'
    ) {
      if (length_buffer != 0) {
        unsigned int index_pointer = 0;

        for (
          unsigned int index_buffer = 0;
          index_buffer < length_buffer;
          ++index_buffer
        ) {
          if (
            buffer[
              index_buffer
            ] == '-'
          ) {
            index_pointer = index_buffer;
            break;
          }
        }

        if (
          index_pointer == 0 ||
          index_pointer + 5 >= length_buffer ||
          buffer[index_pointer + 1] != '>' ||
          buffer[index_pointer + 2] != '{' ||
          buffer[length_buffer - 2] != '}' ||
          buffer[length_buffer - 1] != ';'
        ) {
          debug_log_error(
            "invalid_configuration_file"
          );

          status_configuration_load = 1;

          break;
        }

        char* buffer_parameter;
        unsigned int length_buffer_parameter = (
          index_pointer
        );

        buffer_parameter = malloc(
          sizeof(char) * length_buffer_parameter
        );

        clic3_bytes_copy(
          buffer_parameter,
          buffer,
          length_buffer_parameter
        );

        char* buffer_value;
        unsigned int length_buffer_value = (
          (length_buffer - 2) -
          (index_pointer + 3)
        );

        buffer_value = malloc(
          sizeof(char) * length_buffer_value
        );

        clic3_bytes_copy(
          buffer_value,
          buffer + index_pointer + 3,
          length_buffer_value
        );

        int index_parameter = clic3_char_arrays_within(
          buffer_parameter,
          1,
          "audio:volume"
        );

        if (
          index_parameter == -1
        ) {
          char* message_debug_log_error_prefix = clic3_char_arrays_concatenate(
            "unknown_configuration_parameter->{",
            buffer_parameter
          );

          char* message_debug_log_error = clic3_char_arrays_concatenate(
            message_debug_log_error,
            "};\n"
          );

          debug_log_error(
            message_debug_log_error
          );

          free(message_debug_log_error_prefix);
          free(message_debug_log_error);

          status_configuration_load = 1;

          break;
        }

        switch (index_parameter) {
          case 0: {
            float audio_volume = atof(
              buffer_value
            );

            if (
              audio_volume == 0.0f
            ) {
              unsigned char decimal_point_passed = 0;
              unsigned char valid_parameter = 1;

              for (
                unsigned short int index_buffer_value = 0;
                index_buffer_value < length_buffer_value;
                ++index_buffer_value
              ) {
                if (
                  buffer_value[
                    index_buffer_value
                  ] == '.'
                ) {
                  if (decimal_point_passed == 1) {
                    valid_parameter = 0;
                    break;
                  }

                  decimal_point_passed = 1;
                } else if (
                  buffer_value[
                    index_buffer_value
                  ] != '0'
                ) {
                  valid_parameter = 0;
                  break;
                }
              }

              if (
                valid_parameter == 0
              ) {
                char* message_debug_log_error_prefix = clic3_char_arrays_concatenate(
                  "invalid_configuration_value->{",
                  buffer_parameter
                );

                char* message_debug_log_error_split = clic3_char_arrays_concatenate(
                  message_debug_log_error_prefix,
                  ":"
                );

                char* message_debug_log_error_value = clic3_char_arrays_concatenate(
                  message_debug_log_error_split,
                  buffer_value
                );

                char* message_debug_log_error = clic3_char_arrays_concatenate(
                  message_debug_log_error_value,
                  "};\n"
                );

                debug_log_error(
                  message_debug_log_error
                );

                free(message_debug_log_error_prefix);
                free(message_debug_log_error_split);
                free(message_debug_log_error_value);
                free(message_debug_log_error);

                status_configuration_load = 1;

                break;
              }
            }

            configuration.audio.volume = audio_volume;
            
            break;
          }
        }

        free(buffer_parameter);
        free(buffer_value);

        length_buffer = 0;
      }
    } else {
      length_buffer = (
        length_buffer + 1
      );

      buffer = realloc(
        buffer,
        sizeof(char) * length_buffer
      );

      buffer[
        length_buffer - 1
      ] = c;
    }
  }

  free(buffer);

  fclose(file_configuration);

  return status_configuration_load;
}

void configuration_values_set() {
  audio_data.volume = configuration.audio.volume;
}

void configuration_destroy() {}
