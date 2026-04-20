jryp.components.jryp_zoe_entry_point_component = {
  async content(
    jryp,
    parameters
  ) {
    return [
      "main",
      "zoe",
      await jryp.jryp_component_insert(
        "jryp_zoe_jetil_display_component"
      )
    ];
  },
  styles(
    jryp,
    parameters
  ) {
    return {
    };
  }
};
