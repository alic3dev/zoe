jryp.components.jryp_zoe_jetil_display_component = {
  async content(
    jryp,
    parameters
  ) {
    var id_canvas_jetil_zoe = (
      "canvas_jetil_zoe"
    );

    jetil_zoe_initialize(
      id_canvas_jetil_zoe
    );

    return [
      [
        "canvas",
        [
          "id",
          id_canvas_jetil_zoe
        ],
        [
          "height",
          "1080"
        ],
        [
          "width",
          "1920"
        ]
      ]
    ];
  },
  styles(
    jryp,
    parameters
  ) {
    return {
      "position"     : "fixed",
      "top"          : "0",
      "left"         : "0",
      "right"        : "0",
      "bottom"       : "0",
      "height"       : "100%",
      "width"        : "100%",
      "objectFit"    : "cover",
      "pointerEvents": "none"
    };
  }
};
