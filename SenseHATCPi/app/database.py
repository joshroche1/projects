import psycopg2
from datetime import datetime

DBHOST='127.0.0.1'
DBPORT='5432'
DBNAME='sensehatc'
DBUSER='sensehatc'
DBPASS='sensehatc'

# create table measurements (datetimestamp TIMESTAMPZ, pressure DECIMAL, temp_1 DECIMAL, temp_2 DECIMAL, humidity DECIMAL, color_red INTEGER, color_green INTEGER, color_blue INTEGER, lux INTEGER, color_temp INTEGER)

def db_conn():
  try:
    conn = psycopg2.connect(database=DBNAME, user=DBUSER, password=DBPASS, host=DBHOST, port=DBPORT)
    return conn
  except Exception as ex:
    print(str(ex))
    return

def insert_data(datarr, intarr):
  dt = datetime.now()
  try:
    conn = db_conn()
    cursor = conn.cursor()
    sqlstmt = "INSERT INTO measurements (datetimestamp, pressure, temp_1, temp_2, humidity, color_red, color_green, color_blue, lux , color_temp) VALUES ('"+str(dt)+"',"+str(datarr[0])+","+str(datarr[1])+","+str(datarr[2])+","+str(datarr[3])+","+str(intarr[0])+","+str(intarr[1])+","+str(intarr[2])+","+str(intarr[3])+","+str(intarr[4])+")"
    cursor.execute(sqlstmt)
#    cursor.execute('INSERT INTO measurements VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', dt, datarr[0], datarr[1], datarr[2], datarr[3], intarr[0], intarr[1], intarr[2], intarr[3], intarr[4])
    conn.commit()
    conn.close()
    return ""
  except Exception as ex:
    print(str(ex))
    return str(ex)

#
