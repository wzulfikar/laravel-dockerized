################################################################################
# Base image
################################################################################

FROM nginx

################################################################################
# Build instructions
################################################################################

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*

# Install packages
RUN apt-get update && apt-get install -my \
  nano \
  composer \
  supervisor \
  curl \
  wget \
  php7.0-curl \
  php7.0-fpm \
  php7.0-gd \
  php7.0-mysql \
  php7.0-mcrypt \
  php7.0-xdebug

# Ensure that PHP7 FPM is run as root.
RUN sed -i "s/user = www-data/user = root/" /etc/php/7.0/fpm/pool.d/www.conf
RUN sed -i "s/group = www-data/group = root/" /etc/php/7.0/fpm/pool.d/www.conf

# Add configuration files
RUN rm -f /etc/nginx/nginx.conf && ln -s /opt/conf/nginx.conf /etc/nginx/
RUN rm -f /etc/supervisor/conf.d/supervisord.conf && ln -s /opt/conf/supervisord.conf /etc/supervisor/conf.d/
RUN rm -f /etc/php/7.0/fpm/conf.d/40-custom.ini && ln -s /opt/conf/php.ini /etc/php/7.0/fpm/conf.d/40-custom.ini

# Add aliases
RUN echo 'alias artisan="php artisan"' >> ~/.bashrc

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/etc/nginx/conf.d"]

################################################################################
# Ports
################################################################################

EXPOSE 80 443 9000

################################################################################
# Start phpfpm service
################################################################################

RUN service php7.0-fpm start

################################################################################
# Entrypoint
################################################################################

ENTRYPOINT ["/usr/bin/supervisord"]
