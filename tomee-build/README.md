# tomee-build
Builds a TomEE environment on Ubuntu


# Keystore

To Import a Certificate and Chain


keytool -import -alias tomee -keystore /home/tomee/.keystore -trustcacerts -file CHAINCERTFILE

keytool -import -alias tomee -keystore /home/tomee/.keystore -file CERTFILE
