# Use PostgreSQL 13 as the base image
FROM postgres:13

# Copy init.sql to /docker-entrypoint-initdb.d/; SQL files there run automatically the first time the container starts
COPY ./init/init.sql /docker-entrypoint-initdb.d/

# Copy postgresql.conf to /etc/postgresql/postgresql.conf to replace the default settings
COPY ./config/postgresql.conf /etc/postgresql/custom.conf

# Set the account information
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword
ENV POSTGRES_DB=mydb

EXPOSE 5432

CMD ["postgres", "-c", "config_file=/etc/postgresql/custom.conf"]
