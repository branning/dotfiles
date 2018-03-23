#!/usr/bin/env bash

set -o xtrace

oldhere=$PWD
cd ~/gstwebrtc-demos/sendrecv/gst
trap "cd $oldhere" EXIT INT

#GST_PLUGIN_PATH=$HOME/gst-build/build/subprojects/gst-plugins-base/ext/opus:$HOME/gst-build/build/subprojects/gst-plugins-good/ext/vpx/ \
LD_LIBRARY_PATH=$HOME/src/gstreamer-webrtc/gst-build/build/subprojects/gstreamer/lib:$HOME/src/gstreamer-webrtc/gst-build/build/subprojects/gst-plugins-base/lib:$HOME/src/gstreamer-webrtc/gst-build/build/subprojects/gst-plugins-good/lib:$HOME/src/gstreamer-webrtc/gst-build/build/subprojects/gst-plugins-bad/lib:$HOME/src/gstreamer-webrtc/gst-build/build/subprojects/gst-plugins-ugly/lib:$HOME/src/gstreamer-webrtc/gst-build/build/subprojects/gst-plugins-bad/gst-libs/gst/webrtc:$HOME/gst-build/build/subprojects/gst-plugins-bad/gst-libs/gst/webrtc:$HOME/gst-build/build/subprojects/gst-plugins-base/gst-libs/gst/sdp:$HOME/gst-build/build/subprojects/gstreamer/gst ./webrtc-sendrecv $@

