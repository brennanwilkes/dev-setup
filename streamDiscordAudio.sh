#https://askubuntu.com/questions/421014/share-an-audio-playback-stream-through-a-live-audio-video-conversation-like-sk

#pactl list short sources
#pactl list short sinks

STEREO_SINK_NAME=analog-stereo
STEREO_SINK=$( pactl list short sinks | grep "$STEREO_SINK_NAME" | tr '\t' ' ' | cut -d' ' -f1 )

pactl load-module module-null-sink sink_name=Virtual1 sink_properties=device.description=Virtual1
pactl load-module module-null-sink sink_name=Virtual2 sink_properties=device.description=Virtual2

pactl load-module module-loopback latency_msec=1 sink=Virtual1
pactl load-module module-loopback latency_msec=1 sink=Virtual1 source=Virtual2.monitor

#sink = alsa_output.pci-0000_00_1f.3.analog-stereo
pactl load-module module-loopback latency_msec=1 sink="$STEREO_SINK" source=Virtual2.monitor

pactl set-default-source Virtual1.monitor


#sink = alsa_output.pci-0000_00_1f.3.analog-stereo
pactl set-default-sink "$STEREO_SINK"

############################################################################

pactl list short clients | grep -i 'discord'
#find discord

echo ""
echo "Match ^ number with the third number \\/ "
echo ""

pactl list short source-outputs | tr '\t' ' ' | grep -E '[0-9]+ [0-9]+ [0-9]+' | tr ' ' '\t'
#find matching entry

echo ""
echo "Enter the ^first^ number from above"

read id
#output = above number
pactl move-source-output "$id" Virtual1.monitor

#find audio program (source of stream audio)
pactl list short clients

echo ""
echo "Match ^ number of audio source (video player) with the third number \\/"
echo ""

#match up number
pactl list short sink-inputs | tr '\t' ' ' | grep -E '[0-9]+ [0-9]+ [0-9]+' | tr ' ' '\t'

echo ""
echo "Enter the ^first^ number from above"

read id2

#match up
pactl move-sink-input "$id2" Virtual2
