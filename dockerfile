FROM opensuse/tumbleweed

RUN zypper install -y openSUSE-release-appliance-docker
RUN zypper install -y python3 python3-pip nginx uwsgi supervisor git python3-uwsgi-python3

RUN mkdir -p /srv/www/
RUN git clone https://github.com/F-D-G-L/fdgl-homepage.git /srv/www/fdgl-homepage
RUN chown -R nginx:nginx /srv/www/
RUN pip3 install -r /srv/www/fdgl-homepage/requirements.txt


RUN rm /etc/uwsgi/vassals/*.example
RUN rm -rf /etc/supervisord*
COPY --chown=nginx:nginx nginx.conf /etc/nginx/nginx.conf
COPY --chown=nginx:nginx flask-site-nginx.conf /etc/nginx/conf.d/flask-site-nginx.conf
COPY --chown=nginx:nginx uwsgi.ini /etc/uwsgi/uwsgi.ini
COPY --chown=root:root supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]
