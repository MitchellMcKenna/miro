#!/bin/bash

# This script installs dependencies for building and running Miro on
# Debian Wheezy (currently testing).
#
# You run this sript AT YOUR OWN RISK.  Read through the whole thing
# before running it!
#
# This script must be run with sudo.

# Last updated:    September 1st, 2011
# Last updated by: Will Kahn-Greene

apt-get install \
    build-essential \
    dbus-x11 \
    ffmpeg
    gstreamer0.10-ffmpeg \
    gstreamer0.10-plugins-bad \
    gstreamer0.10-plugins-base \
    gstreamer0.10-plugins-good \
    gstreamer0.10-plugins-ugly \
    libavahi-compat-libdnssd1 \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libboost1.46-dev \
    libsoup2.4-dev \
    libtag1-dev \
    libtorrent-rasterbar6 \
    libwebkit-dev \
    libwebkitgtk-3.0-0 \
    pkg-config \
    python-gconf \
    python-gst0.10 \
    python-gtk2-dev \
    python-libtorrent \
    python-mutagen \
    python-pycurl \
    python-pyrex \
    python-webkit \
    zlib1g-dev \
