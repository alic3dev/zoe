var jryp_id_entry_point = (
  "jryp_entry_point"
);

var jryp_component_entry_point = (
  "jryp_zoe_entry_point_component"
);

function jryp_zoe_initialize() {
  jryp_initialize(
    jryp_id_entry_point,
    jryp_component_entry_point
  );
}

if (
  document.readyState ==
  "loading"
) {
  document.addEventListener(
    "DOMContentLoaded",
    jryp_zoe_initialize
  );
} else {
  jryp_zoe_initialize();
}
