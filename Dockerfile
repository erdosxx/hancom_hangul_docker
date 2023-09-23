FROM ubuntu:20.04

RUN apt update
# Download from https://yadi.sk/d/G4vRRdsLZznPng
COPY hoffice_hwp_2020_amd64.deb /root/
COPY hwp.sh /root/

# For ibus setting: Add Hangul input with toggling by <F8> key.
# Ref: https://unix.stackexchange.com/questions/49452/where-is-config-file-of-ibus-stored
COPY ibus.dconf /root/

WORKDIR /root

RUN apt install libharfbuzz-icu0 -y

# For keyboard-configuration package
# This file supports automatic selection of keyboard: 59(Korean), 2 (Koren (101/104 key compatible))
# without manual selection when install.
# Ref: https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package
COPY selections.conf /root/
RUN apt install debconf-utils -y
RUN debconf-set-selections < selections.conf
RUN apt install ibus ibus-hangul -y
RUN apt install fonts-noto-cjk -y

# Install libraries in run time dependencies
RUN apt install libglu1 -y
RUN apt install libcurl3-gnutls -y
RUN apt install libcairo2 -y
RUN apt install libdbus-1-3 -y
# Ref: https://github.com/NVlabs/instant-ngp/discussions/300
RUN apt-get install '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev -y
RUN apt install libglib2.0-bin -y
RUN apt install gsettings-desktop-schemas -y

# locale setting to supoort Korean filename.
RUN apt-get install -y locales locales-all
ENV LC_ALL ko_KR.UTF-8
ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR.UTF-8
ENV XDG_RUNTIME_DIR /tmp/runtime-root

RUN dpkg -i hoffice_hwp_2020_amd64.deb

ARG GetMyHome
RUN mkdir -p ${GetMyHome}
ENV HOME ${GetMyHome}
WORKDIR ${HOME}
