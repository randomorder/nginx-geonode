FROM nginx
MAINTAINER GeoNode development team

ADD *.envsubst /etc/nginx/
ADD docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

