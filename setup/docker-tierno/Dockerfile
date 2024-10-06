FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# Locations.
ARG INSTALL_PATH=/opt/snitchdns
ARG DATA_PATH=$INSTALL_PATH/data
ARG CONFIG_PATH=$DATA_PATH/config
ARG REPO=https://github.com/tiernogalvan/dns.tiernogalvan.es

# Configuration.
ARG SNITCHDNS_DBMS=sqlite
ARG SNITCHDNS_DB_USER=none
ARG SNITCHDNS_DB_PW=none
ARG SNITCHDNS_DB_URL=none
ARG SNITCHDNS_DB_DB=none
ARG SNITCHDNS_SECRET_KEY=RosesAreRedVioletsAreBlueThisMustBeSecretAsWellAsLongToo

ARG SNITCH_DOMAIN=dns.tiernogalvan.es
ARG BASE_DOMAIN=dns.tiernogalvan.es

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Install pre-requisites.
RUN apt update && \
    apt install -y \
    git \
    python3-pip \
    python3-venv \
    libpq-dev \
    cron \
    iptables && rm -rf /var/lib/apt/lists/*

# Install SnitchDNS.
RUN git clone $REPO /opt/snitchdns

WORKDIR $INSTALL_PATH

RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip --no-cache-dir install -r requirements.txt && \
    deactivate

# Configure SnitchDNS.
RUN mkdir -p $CONFIG_PATH/env
RUN mkdir -p $CONFIG_PATH/service
RUN mkdir -p $CONFIG_PATH/http
RUN touch $CONFIG_PATH/env/snitch.conf && \
    echo SNITCHDNS_DBMS=$SNITCHDNS_DBMS > $CONFIG_PATH/env/snitch.conf && \
    echo SNITCHDNS_DB_USER=$SNITCHDNS_DB_USER >> $CONFIG_PATH/env/snitch.conf && \
    echo SNITCHDNS_DB_PW=$SNITCHDNS_DB_PW >> $CONFIG_PATH/env/snitch.conf && \
    echo SNITCHDNS_DB_URL=$SNITCHDNS_DB_URL >> $CONFIG_PATH/env/snitch.conf && \
    echo SNITCHDNS_DB_DB=$SNITCHDNS_DB_DB >> $CONFIG_PATH/env/snitch.conf && \
    echo SNITCHDNS_SECRET_KEY=$SNITCHDNS_SECRET_KEY >> $CONFIG_PATH/env/snitch.conf
RUN ln -s $CONFIG_PATH/env/snitch.conf $INSTALL_PATH/.env

RUN ./venv.sh flask db init && \
    ./venv.sh flask db migrate && \
    ./venv.sh flask db upgrade && \
    ./venv.sh flask snitchdb && \
    ./venv.sh flask crontab add

RUN ./venv.sh flask settings set --name dns_daemon_bind_ip --value 0.0.0.0 && \
    ./venv.sh flask settings set --name dns_daemon_bind_port --value 2024 && \
    ./venv.sh flask settings set --name dns_base_domain --value $BASE_DOMAIN

VOLUME $DATA_PATH

EXPOSE 8888 2024

CMD ["/bin/bash", "setup/docker-tierno/entrypoint.sh"]
