#!/bin/bash

# built on Ubuntu 20.04.03 Focal

apt-get update && apt-get upgrade -y
apt-cache search graphite | grep "graphite-"
apt-cache madison graphite-web graphite-carbon
apt-get install graphite-carbon graphite-web
cat /etc/carbon/carbon.conf | egrep -v '#' | sed '/^$/d'

vim /etc/default/graphite-carbon
Change to true, to enable carbon-cache on boot
CARBON_CACHE_ENABLED=true

systemctl start carbon-cache
vim /etc/graphite/local_settings.py
...
SECRET_KEY = 'MY_SECRET' # enter your own secret key

django-admin migrate --settings=graphite.settings

sed -i 's/from cgi import parse_qs/from urllib.parse import parse_qs/' /usr/lib/python3/dist-packages/graphite/render/views.py
find / -name app_settings.py 2>/dev/null
sed -i -E "s/('django.contrib.contenttypes')/\1,\n  'django.contrib.messages'/" /usr/lib/python3/dist-packages/graphite/app_settings.py
django-admin migrate --settings=graphite.settings

chown _graphite:_graphite /var/lib/graphite/graphite.db
apt-get install apache2 libapache2-mod-wsgi-py3 -y
cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available
a2dissite 000-default
a2ensite apache2-graphite
systemctl reload apache2
chown _graphite:_graphite /var/log/graphite/info.log
chown _graphite:_graphite /var/log/graphite/exception.log

django-admin createsuperuser --settings=graphite.settings
