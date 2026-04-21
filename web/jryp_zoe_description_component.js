jryp.components.jryp_zoe_description_component = {
  async content(
    jryp,
    parameters
  ) {
    return [
      "div",
      [
        "p",
        [
          [
            "a",
            [
              "href",
              "https://alic3.dev"
            ]
          ],
          "alic3dev"
        ],
      ],
      [
        "p",
        [
          [
            "a",
            [
              "href",
              "https://github.com/alic3dev/zoe"
            ]
          ],
          "code_source"
        ]
      ],
      [
        "p",
        "available_on->{macos|ios};"
      ]
    ];
  },
  styles(
    jryp,
    parameters
  ) {
    return {
      "position"     : "fixed",
      "bottom"       : "0",
      "left"         : "0",
      "margin"       : "0",
      "padding"      : "20px",
      "font-size"    : "10px",
      "line-height"  : "10px",
      "color"        : "#ffffff",
      "zIndex"       : "1"
    };
  }
};
