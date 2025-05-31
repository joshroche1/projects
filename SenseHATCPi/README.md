# Sensor Data Collector for Waveshare Sense HAT(C) for Raspberry Pi

## References

- [https://www.waveshare.com/wiki/Sense_HAT_(C)](https://www.waveshare.com/wiki/Sense_HAT_(C))

## Dependencies

- Sense HAT(C)
- Raspberry PI
- PostgreSQL database

- python3-psycopg2

## Tutorial

- Copy `app/` folder to Raspberry Pi
- Edit `app/database.py` DB* variables for database connection
- Initialize database table: `create table measurements (datetimestamp TIMESTAMPZ, pressure DECIMAL, temp_1 DECIMAL, temp_2 DECIMAL, humidity DECIMAL, color_red INTEGER, color_green INTEGER, color_blue INTEGER, lux INTEGER, color_temp INTEGER)`
- Run: `python3 main.py` in the directory

#
