--- SQL Schema EnviroPlus

CREATE TABLE measurements (
  dtime TIMESTAMP,
  temperature DECIMAL,
  pressure DECIMAL,
  humidity DECIMAL,
  light DECIMAL,
  oxidised DECIMAL,
  reduced DECIMAL,
  nh3 DECIMAL,
  pm1 DECIMAL,
  pm25 DECIMAL,
  pm10 DECIMAL
);

INSERT INTO measurements (
  dtime,temperature,pressure,humidity,light,oxidised,reduced,nh3,pm1,pm25,pm10
)
VALUES (
  '2000-01-01 00:00:00',
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0
);