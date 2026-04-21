jryp.components.jryp_zoe_entry_point_component = {
  async content(
    jryp,
    parameters
  ) {
    return [
      "main",
      await jryp.jryp_component_insert(
        "jryp_zoe_title_component"
      ),
      await jryp.jryp_component_insert(
        "jryp_zoe_description_component"
      ),
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
