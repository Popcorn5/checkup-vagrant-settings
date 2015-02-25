#!/usr/bin/env bash

apt-get update
apt-get install -y nginx postgresql postgresql-contrib libpq-dev python python-dev python-pip git supervisor

if [ ! -d "/vagrant/checkup-backend-django" ]; then
    echo "Cloning Backend Repository..."
    git clone https://dc6776c6c16793a4766a780255c37ddb1ab20d6f@github.com/Popcorn5/checkup-backend-django.git /vagrant/checkup-backend-django
    cd /vagrant/checkup-backend-django
    git checkout develop
fi

pip install uwsgi virtualenv

# Create virtualenv environment
if [ ! -d "/srv/env" ]; then
    virtualenv /srv/env
    # Export environment variables to activate script
    echo "export DJANGO_SECRET_KEY=neAYI4sgkKx0ZfRv4ltprXVrDK3g" >> /srv/env/bin/activate
    echo "export DJANGO_DEBUG=True" >> /srv/env/bin/activate
    echo "export DJANGO_STATIC_ROOT=/srv/static" >> /srv/env/bin/activate
    echo "export DJANGO_MEDIA_ROOT=/srv/media" >> /srv/env/bin/activate
    echo "export DJANGO_DATABASE_URL=postgres://popcorn:five@localhost:5432/checkup" >> /srv/env/bin/activate
    echo "export DJANGO_MANDRILL_KEY=OklzU9hKJFG6F3w0ltLpoA" >> /srv/env/bin/activate
fi

source /srv/env/bin/activate
pip install -r /vagrant/checkup-backend-django/requirements.pip

if [ ! -d "/srv/static" ]; then
    mkdir /srv/static
fi

if [ ! -d "/srv/media" ]; then
    mkdir /srv/media
fi

python /vagrant/checkup-backend-django/checkup/manage.py collectstatic --noinput


# Create PostgreSQL user & database
if [ -z "$(su --login postgres --command 'psql -l | grep checkup')" ]; then
    echo "Creating user..."
    su --login postgres --command "psql -c \"CREATE USER popcorn WITH PASSWORD 'five'\""
    su --login postgres --command "psql -c \"ALTER USER popcorn CREATEDB\""
    su --login postgres --command "psql -C \"CREATE DATABASE checkup OWNER popcorn\""
fi


# Create logging folder...
if [ ! -d "/var/log/checkup" ]; then
    mkdir /var/log/checkup
fi

# Create uWSGI folder...
if [ ! -d "/srv/api" ]; then
    mkdir /srv/api
fi

if [ -f "/etc/nginx/sites-enabled/default" ]; then
    rm /etc/nginx/sites-enabled/default
fi

# Copy configuration files to appropriate places...
cp /vagrant/checkup-config/checkup_nginx.conf /etc/nginx/sites-enabled
cp /vagrant/checkup-config/checkup_supervisor.conf /etc/supervisor/conf.d
cp /vagrant/checkup-config/checkup_uwsgi.ini /srv/api

# Restart necessary services...
nginx -s reload
supervisorctl reload
