FROM dimitri/pgloader

COPY rds-load /usr/local/bin/

WORKDIR /data-loader

ADD ppl_people_load /data-loader/

RUN apt-get update && \
	apt-get install -y awscli

CMD ["rds-load"]
