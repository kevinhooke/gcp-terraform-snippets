FROM ubuntu:24.04
RUN apt-get update -y
RUN apt-get install nginx -y

COPY /config/nginx.conf /etc/nginx/conf.d/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]