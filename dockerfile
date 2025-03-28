#FROM alpine:latest
FROM ubuntu:latest
# Setting Local Environment Variables - MJW
ENV PANDORAUSER="user@email.com"
ENV PANDORAPASS="password"
ENV MUSICSORT="quickmix_10_name_az"
ENV AUDIOQUALITY="high"
ENV AUTOSTART=""
ARG DEBIAN_FRONTEND=noninteractive

# Dockerfile only arguments
#ARG LUAVERS="5.1"

# Alpine Install Dependencies and Pianobar
#RUN apk add build-base luajit luarocks${LUAVERS} lua${LUAVERS}-dev openssl-dev alsa-utils pianobar git nano htop vim lua-socket
#RUN apk add lua-sec
#RUN apk add libc-dev lib6-dev liblua5.1-0 libreadline-dev liblua5.1-0-dev
#RUN apk add dpkg
#RUN dpkg --update-avail
#RUN dpkg install liblua5-dev 

# Ubuntu Install Dependencies and Pianobar
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install vim \
	rsync \
	luajit \
	luarocks \
	libssl-dev \
	alsa-utils \
	pianobar \
	git \
	nano \
	htop \
	vim \
	lua-socket \
	build-essential \
	make
RUN apt-get -y install lua-sec \
	liblua5.1-0 \
	libreadline-dev \
	liblua5.1-dev

RUN apt-get update && apt-get -y upgrade
# Originally set to /opt/remodora
WORKDIR /app/remodora
COPY . ./

# Install LUA components
RUN luarocks install turbo
RUN luarocks install penlight
RUN luarocks install luasocket
RUN luarocks install lua_json


# Set up pianobar
# TODO: Make config use ENV variable
# NOTE: Attempts to use the ENV defined in here fails epically.
# MJW 20250328

RUN mkdir --parents ~/.config/pianobar
RUN cp ./src/support/events.lua ~/.config/pianobar/events.lua
RUN sed -i "s|%s|~/.config/pianobar|g" ~/.config/pianobar/events.lua
RUN chmod +x ~/.config/pianobar/events.lua
RUN mkfifo ~/.config/pianobar/ctl

# Write initial config
RUN echo "user = ${PANDORAUSER}" >> ~/.config/pianobar/config
RUN echo "password = ${PANDORAPASS}" >> ~/.config/pianobar/config
RUN echo "autostart_station = ${AUTOSTART}" >> ~/.config/pianobar/config
#RUN echo "sort = ${MUSICSORT}" >> ~/.config/pianobar/config
RUN echo "audio_quality = ${AUDIOQUALITY}" >> ~/.config/pianobar/config
RUN echo "event_command = /root/.config/pianobar/events.lua" >> ~/.config/pianobar/config
RUN echo "fifo = /root/.config/pianobar/ctl" >> ~/.config/pianobar/config

#COPY configure.sh /app/configure.sh
RUN chmod +x ./configure.sh
#ENTRYPOINT ["./configure.sh"]
CMD ["./configure.sh"]
