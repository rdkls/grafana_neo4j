from	ubuntu:14.04
run	echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty universe' >> /etc/apt/sources.list
run	apt-get -y update
run	apt-get -y install software-properties-common &&\
	apt-get -y update
run     apt-get -y install nodejs python-django-tagging python-simplejson python-memcache \
			    python-ldap python-cairo python-django python-twisted   \
			    python-pysqlite2 python-support python-pip gunicorn     \
			    supervisor nginx-light nodejs git wget curl

run     apt-get -y install python-dev libffi-dev

# Install statsd
run	mkdir /src && git clone https://github.com/etsy/statsd.git /src/statsd

# Install required packages
run	pip install whisper pytz
run	pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib" carbon
run	pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/webapp" graphite-web

# grafana
run     cd ~ &&\
       wget https://grafanarel.s3.amazonaws.com/builds/grafana_3.1.0-1466666977beta1_amd64.deb &&\
        dpkg -i grafana_3.1.0-1466666977beta1_amd64.deb && rm grafana_3.1.0-1466666977beta1_amd64.deb

# statsd
add	./statsd/config.js /src/statsd/config.js

# Add graphite config
add	./graphite/initial_data.json /var/lib/graphite/webapp/graphite/initial_data.json
add	./graphite/local_settings.py /var/lib/graphite/webapp/graphite/local_settings.py
add	./graphite/carbon.conf /var/lib/graphite/conf/carbon.conf
add	./graphite/storage-schemas.conf /var/lib/graphite/conf/storage-schemas.conf
add	./graphite/storage-aggregation.conf /var/lib/graphite/conf/storage-aggregation.conf

# Add grafana config
add     ./grafana/config.ini /etc/grafana/config.ini
add	./neo4j/neo4j-dashboard.json /etc/grafana/neo4j-dashboard.json
add	./neo4j/grafana-neo4j-datasource.json /etc/grafana/grafana-neo4j-datasource.json

# Add system service config
add	./nginx/nginx.conf /etc/nginx/nginx.conf
add	./supervisord.conf /etc/supervisor/conf.d/supervisord.conf


# Nginx
#
# graphite
expose	80
# grafana
expose  3000

# Carbon line receiver port
expose	2003
# Carbon pickle receiver port
expose	2004
# Carbon cache query port
expose	7002

# Statsd UDP port
expose	8125/udp
# Statsd Management port
expose	8126

add ./bin/init /usr/bin/init

entrypoint ["/usr/bin/init"]
