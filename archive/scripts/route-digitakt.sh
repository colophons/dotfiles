#!/bin/sh
input="alsa_input.usb-Elektron_Music_Machines_Elektron_Digitakt_000000000001-00.analog-stereo"
output="alsa_output.usb-Schiit_Audio_I_m_Fulla_Schiit-00.analog-stereo"

#pacat -r --latency-msec=1 -d "$input" | pacat -p --latency-msec=1 -d "$output"

gst-launch-1.0 pulsesrc device="$input" ! pulsesink device="$output"
