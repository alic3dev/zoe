jryp.components.jryp_zoe_title_component = {
  async content(
    jryp,
    parameters
  ) {
    return [
      "h1",
      "zoe"
    ];
  },
  styles(
    jryp,
    parameters
  ) {
    return {
      "position"     : "fixed",
      "top"          : "0",
      "right"        : "0",
      "margin"       : "0",
      "padding"      : "0",
      "font-size"    : "min(50dvh, 50dvw)",
      "line-height"  : "min(25dvh, 25dvw)",
      "pointerEvents": "none",
      "userSelect"   : "none",
      "color"        : "var(--colour_white)",
      "zIndex"       : "1"
    };
  }
};
