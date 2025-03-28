#!/bin/bash
# configure.sh
# ENV available and default values:
# PANDORAUSER="user"
# PANDORAPASS="password"
# MUSICSORT="quickmix_10_name_az"
# AUDIOQUALITY="high"
# AUTOSTART=""
# EVENTCOMMAND="./remodora" # Note the './' indicating local application

# Update the config file using relative path (assuming your Dockerfile and these variables are in the same directory)
cp /root/.config/pianobar/config /root/.config/pianobar/config.default
echo "user = $PANDORAUSER" > /root/.config/pianobar/config
echo "pass = $PANDORAPASS" >> /root/.config/pianobar/config
echo "autostart_station = $AUTOSTART" >> /root/.config/pianobar/config
#echo "sort = $MUSICSORT" >> /root/.config/pianobar/config
echo "audio_quality = $AUDIOQUALITY" >> /root/.config/pianobar/config
echo "event_command = ~/.config/pianobar/events.lua" >> /root/.config/pianobar/config
echo "fifo = ~/.config/pianobar/ctl" >> /root/.config/pianobar/config
# Start the application
exec "./remodora"
