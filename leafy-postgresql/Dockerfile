#PostgreSQL 13 버전을 베이스 이미지로 사용
FROM postgres:13

#init.sql파일을 /docker-entrypoint-initdb.d/ 로 복사, /docker-entrypoint-initdb.d/에 있는 sql문은 컨테이너가 처음 실행 시 자동실행됨
COPY ./init/init.sql /docker-entrypoint-initdb.d/

#postgresql.conf파일을 /etc/postgresql/postgresql.conf 로 복사, 기본 설정 파일을 덮어쓰기하여 새로운 설정 적용
COPY ./config/postgresql.conf /etc/postgresql/custom.conf

#계정정보 설정
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword
ENV POSTGRES_DB=mydb

EXPOSE 5432

CMD ["postgres", "-c", "config_file=/etc/postgresql/custom.conf"]
