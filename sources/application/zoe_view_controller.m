#include <application/zoe_view_controller.h>

#include <application/zoe_view.h>
#include <input/keycodes.h>
#include <input/map.h>
#include <menus/menu.h>
#include <menus/menu_intro.h>
#include <rendering/zoe_renderer.h>
#include <termination.h>

struct menu menu_intro;
unsigned char menu_closing = 0;

void zoe_view_controller_on_termination() {
  menu_destroy(&menu_intro);
}

void menu_print(
  struct menu* menu
) {
  printf("\e[H\e[2J\e[3J");

  if (
    menu->index_selected == 0
  ) {
    printf(
      "> start\n"
      "  exit\n"
    );
  } else if (
    menu->index_selected == 1
  ) {
    printf(
      "  start\n"
      "> exit\n"
    );
  } else {
    printf(
      "  start\n"
      "  exit\n"
    );
  }
}

void on_selection_change(
  struct menu* menu
) {
  menu_print(menu);
}

void on_start() {
  printf("STARTING\n");
  menu_closing = 1;
}

void on_exit() {
  printf("EXITING\n");
  menu_closing = 1;
  [[NSApplication sharedApplication] terminate: 0];
}

@implementation zoe_view_controller {
  zoe_view* view;
  zoe_renderer* renderer;
}

- (void) viewDidLoad {
  [super viewDidLoad];

  view = (zoe_view*) self.view;
  view.device = MTLCreateSystemDefaultDevice();

  renderer = [
    [zoe_renderer alloc]
    initWithMetalKitView: view
  ];

  [renderer
    drawableSizeWillChange: view.bounds.size
  ];

  menu_closing = 0;

  menu_intro_initialize(
    &menu_intro,
    on_start,
    on_exit
  );

  menu_intro.on_selection_change = on_selection_change;

  menu_print(&menu_intro);

  termination_on_function_add(
    zoe_view_controller_on_termination,
    (void*)0
  );

  view.delegate = self;
}

- (void) drawInMTKView: (nonnull zoe_view*) _view {
  [renderer
    drawInMTKView: _view
  ];

  if (menu_closing == 1) {
    menu_destroy(&menu_intro);
    termination_on_function_remove(zoe_view_controller_on_termination);
    menu_closing = 2;
    return;
  } else if (menu_closing == 2) {
    return;
  }

  if (
    input_map_keydown[
      keycode_space
    ] == 1
  ) {
    menu_select(
      &menu_intro
    );

    return;
  }

  if (
    input_map_keydown[
      keycode_up_arrow
    ] == 1
  ) {
    menu_previous(
      &menu_intro
    );
  }

  if (
    input_map_keydown[
      keycode_down_arrow
    ] == 1
  ) {
    menu_next(
      &menu_intro
    );
  }
}

- (void) mtkView: (nonnull zoe_view*) _view drawableSizeWillChange: (CGSize) size {
  [renderer
    drawableSizeWillChange: _view.bounds.size
  ];
}

@end
