FROM postgres:13

COPY ./init/init.sql /docker-entrypoint-initdb.d/

COPY ./config/postgresql.conf /etc/postgresql/postgresql.conf

ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword
ENV POSTGRES_DB=mydb

EXPOSE 5432