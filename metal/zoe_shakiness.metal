float4 zoe_shakiness_get(
  unsigned long int time,
  unsigned long int offset,
  unsigned long int speed,
  float amount
) {
  unsigned long int value = (
    (
      time /
      speed +
      offset
    ) %
    100
  );

  if (
    (
      value %
      2
    ) == 0
  ) {
    amount = (
      -amount
    );
  }

  float4 position_vertex_shaken;

  position_vertex_shaken.x = (
    (
      (float)
      value /
      100.0f
    ) *
    amount
  );

  value = (
    (
      value + 13
    ) %
    100
  );

  position_vertex_shaken.y = (
    (
      (float)
      value /
      100.0f
    ) *
    amount
  );

  value = (
    (
      value + 31
    ) %
    100
  );

  position_vertex_shaken.z = (
    (
      (float)
      value /
      100.0f
    ) *
    amount
  );

  position_vertex_shaken.w = (
    0.0f
  );

  return (
    position_vertex_shaken
  );
}
