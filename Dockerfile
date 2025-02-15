FROM python:3.6

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL maintainer="oc@co.ru" \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.name="Electrum wallet" \
	org.label-schema.description="Electrum wallet with JSON-RPC enabled (daemon mode)" \
	org.label-schema.url="https://electrum.org" \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.vcs-url="https://github.com/osminogin/docker-electrum-daemon" \
	org.label-schema.version=$VERSION \
	org.label-schema.docker.cmd='docker run -d --name electrum-daemon --publish 127.0.0.1:7000:7000 --volume /srv/electrum:/data osminogin/electrum-daemon' \
	org.label-schema.schema-version="1.0"

ENV ELECTRUM_VERSION $VERSION
ENV ELECTRUM_USER electrum
ENV ELECTRUM_PASSWORD electrumz
ENV ELECTRUM_HOME /home/$ELECTRUM_USER
RUN apt-get update -y
RUN apt-get install -y python3-pyqt5
RUN pip3 install https://github.com/Electron-Cash/Electron-Cash/releases/download/4.0.7/Electron-Cash-4.0.7.tar.gz
RUN useradd -ms /bin/bash $ELECTRUM_USER

RUN mkdir -p ${ELECTRUM_HOME}/.electrum/ /data/ && \
	ln -sf ${ELECTRUM_HOME}/.electrum/ /data/ && \
	chown ${ELECTRUM_USER} ${ELECTRUM_HOME}/.electrum

USER $ELECTRUM_USER
WORKDIR $ELECTRUM_HOME
VOLUME /data

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 7000
CMD ["electron-cash"]
