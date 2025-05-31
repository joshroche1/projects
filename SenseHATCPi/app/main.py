#!/usr/bin/python3

import AD
#import IMU
import LPS22HB
import SHTC3
from TCS34087 import TCS34087
import time
import logging
from database import insert_data

logger = logging.getLogger(__name__)

# AD [['AIN0', '963'], ['AIN1', '979'], ['AIN2', '995'], ['AIN3', '1011']]
# LPS22HB [['Pressure', '990.217041015625'], ['Temperature', '32.44']]
# SHTC3 [['Temperature', '32.05650329589844'], ['Humidity', '37.77923583984375']]
# R: 73 G: 32 B: 18 C: 0x1ee5 RGB565: 0x4902 RGB888: 0x492012 LUX: 8 CT: 2481K INT: 1 
# create table measurements (datetimestamp TIMESTAMPZ, pressure DECIMAL, temp_1 DECIMAL, temp_2 DECIMAL, humidity DECIMAL, color_red INTEGER, color_green INTEGER, color_blue INTEGER, lux INTEGER, color_temp INTEGER)

def main():
  Light=TCS34087(0X29, debug=False)
  if(Light.TCS34087_init() == 1):
    print("TCS34087 initialization error!!")
  while True:
    datarr = [0.0, 0.0, 0.0, 0.0]
    intarr = [0, 0, 0, 0, 0]
#    ad_data = AD.read_sensors()
#    if 'error' in ad_data:
#      logger.warning(ad_data['error'])
#    else:
#      print(ad_data['data'])
#    imu_data = IMU.read_sensors()
#    if 'error' in imu_data:
#      logger.warning(imu_data['error'])
#    else:
#      print(imu_data['data'])
    lps_data = LPS22HB.read_sensors()
    if 'error' in lps_data:
      logger.warning(lps_data['error'])
    else:
      datarr[0] = lps_data['data'][0][1]
      datarr[1] = lps_data['data'][1][1]
    sht_data = SHTC3.read_sensors()
    if 'error' in sht_data:
      logger.warning(sht_data['error'])
    else:
      datarr[2] = sht_data['data'][0][1]
      datarr[3] = sht_data['data'][1][1]
      print(sht_data['data'])
    Light.Get_RGBData()
    Light.GetRGB888()
    Light.GetRGB565()
    intarr[0] = Light.RGB888_R
    intarr[1] = Light.RGB888_G
    intarr[2] = Light.RGB888_B
    intarr[3] = Light.Get_Lux()
    intarr[4] = Light.Get_ColorTemp()
    result = insert_data(datarr, intarr)
    if result != "":
      logger.warning(result)
    time.sleep(10.0)
#    print("R: %d "%Light.RGB888_R, end = "")
#    print("G: %d "%Light.RGB888_G, end = "")
#    print("B: %d "%Light.RGB888_B, end = "") 
#    print("C: %#x "%Light.C, end = "")
#    print("RGB565: %#x "%Light.RG565, end ="")
#    print("RGB888: %#x "%Light.RGB888, end = "")   
#    print("LUX: %d "%Light.Get_Lux(), end = "") 
#    print("CT: %dK "%Light.Get_ColorTemp(), end ="")
#    print("INT: %d "%Light.GetLux_Interrupt())

if __name__ == '__main__':
  main()
#
