import time
import sys
import psycopg2

from enviroplus import gas
from bme280 import BME280
from smbus2 import SMBus

try:
  from ltr559 import LTR559
  ltr559 = LTR559()
except ImportError:
  import ltr559

DB_HOST="192.168.2.222"
DB_NAME="environment_sensors"

bus = SMBus(1)
bme280 = BME280(i2c_dev=bus)

def insert_db(readings):
  try:
    conn = psycopg2.connect(host=DB_HOST, dbname=DB_NAME)
    cur = conn.cursor()
    cur.execute("INSERT INTO measurements (datetimestamp,temperature,pressure,humidity,light,oxidised,reduced,nh3) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", (readings[0], readings[1], readings[2], readings[3], readings[4], readings[5], readings[6], readings[7]))
    conn.commit()
    cur.close()
    conn.close()
    return "DB insert successful"
  except Exception as ex:
    return str(ex)

def read_gas():
  try:
    tmpdict = {}
    nh3 = gas.read_nh3()
    oxidising = gas.read_oxidising()
    reducing = gas.read_reducing()
    tmpdict = {
      "nh3": nh3,
      "oxidising": oxidising,
      "reducing": reducing
    }
    return tmpdict
  except Exception as ex:
    print(str(ex))
    return

def read_light():
  try:
    tmpdict = {}
    lux = ltr559.get_lux()
    prox = ltr559.get_proximity()
    tmpdict = {
      "lux": lux,
      "proximity": prox
    }
    return tmpdict
  except Exception as ex:
    print(str(ex))
    return

def read_weather():
  try:
    tmpdict = {}
    temp = bme280.get_temperature()
    pressure = bme280.get_pressure()
    humidity = bme280.get_humidity()
    tmpdict = {
      "temperature": temp,
      "humidity": humidity,
      "pressure": pressure
    }
    return tmpdict
  except Exception as ex:
    print(str(ex))
    return

def main():
  try:
    while True:
      timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
      gasdict = read_gas()
      lightdict = read_light()
      weatherdict = read_weather()
      outstr = timestamp+"\nOxidising: "+str(gasdict['oxidising'])+" Ohms\nReducing: "+str(gasdict['reducing'])+" Ohms\nNH3: "+str(gasdict['nh3'])+" Ohms\nTemperature: "+str(weatherdict['temperature'])+" C\nPressure: "+str(weatherdict['pressure'])+" hPa\nHumidity: "+str(weatherdict['humidity'])+" %\nLight: "+str(lightdict['lux'])+"Lux\n"
      print(outstr)
      # datetimestamp,temperature,pressure,humidity,light,oxidised,reduced,nh3
      readings = [
        timestamp,
        weatherdict['temperature'],
        weatherdict['pressure'],
        weatherdict['humidity'],
        lightdict['lux'],
        gasdict['oxidising'],
        gasdict['reducing'],
        gasdict['nh3']
      ]
      result = insert_db(readings)
      print(result)
      time.sleep(30.0)
  except KeyboardInterrupt:
    sys.exit(0)

if __name__ == "__main__":
  main()