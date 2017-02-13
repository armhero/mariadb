FROM armhero/alpine:3.5

ENV LC_ALL=en_GB.UTF-8

RUN apk upgrade --update --no-cache \
  && apk add --no-cache --update \
    mariadb \
    mariadb-client \
  && mkdir /docker-entrypoint-initdb.d \
  && sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf \
  && echo -e 'skip-host-cache\nskip-name-resolve' | awk '{ print } $1 == "[mysqld]" && c == 0 { c = 1; system("cat") }' /etc/mysql/my.cnf > /tmp/my.cnf \
  && mv /tmp/my.cnf /etc/mysql/my.cnf \
  && rm -rf /tmp/src

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3306
