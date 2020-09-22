FROM python:3.7.6

# set label
LABEL maintainer="NG6"
ARG S6_VER=2.0.0.1
ENV TZ=Asia/Shanghai TASK=1d PUID=1026 PGID=100 UMASK=022

# install subfinder
RUN apt -y update && apt -y install wget curl tzdata \
# install s6-overlay
&&  if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi  \
&&  wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.gz  \
&&  tar -xvzf s6-overlay-${s6_arch}.tar.gz  \
&&  rm s6-overlay-${s6_arch}.tar.gz \
# create abc user
&&  useradd -u 1000 -U -d /config -s /bin/false abc \
&&  usermod -G users abc  \
&&  echo "**** cleanup ****" \
&&  apt-get clean \
&&  rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# copy local files
COPY root/ /

# volumes
VOLUME /config	/media

ENTRYPOINT [ "/init" ]