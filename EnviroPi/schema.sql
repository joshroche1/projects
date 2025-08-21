--- SQL Schema EnviroPlus

CREATE TABLE measurements (
  datetimestamp TIMESTAMP,
  temperature DECIMAL,
  pressure DECIMAL,
  humidity DECIMAL,
  light DECIMAL,
  oxidising DECIMAL,
  reducing DECIMAL,
  nh3 DECIMAL
);

INSERT INTO measurements (
  datetimestamp,temperature,pressure,humidity,light,oxidising,reducing,nh3
)
VALUES (
  '2025-01-01 00:00:00',
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0
);