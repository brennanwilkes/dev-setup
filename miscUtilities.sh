#!/bin/sh

[ -z "$1" ] && {
	[ -f "$HOME/.bash_profile" ] && {
		BASHFILE="$HOME/.bash_profile"
	} || {
		BASHFILE="$HOME/.bashrc"
	}
} || {
	BASHFILE="$1"
}

addToFile(){
	file="${1:-${BASHFILE}}"
	read line
	grep -qxF "$line" "$file" || echo "$line" >> "$file"
}


header='############### MISC UTILITIES ###############'
grep -qxF "$header" "$BASHFILE" || echo "\n$header" >> "$BASHFILE"
echo 'alias please="sudo"' | addToFile
echo 'alias record="export WINDOWID=\$(xdotool getwindowfocus) ; ttyrec ; ttygif ttyrecord ; rm ttyrecord"' | addToFile
echo 'alias compile="g++ *.cpp -Wall -g -fsanitize=address -std=c++14 -o main"' | addToFile
echo 'alias restart-audio="pulseaudio -k && sudo alsa force-reload"' | addToFile
echo 'alias editBashrc="gedit ~/.bashrc && source ~/.bashrc"' | addToFile
echo 'kill-name () { proc="$1" ; ps -aux | grep "$proc" | tr -s " " | cut -d" " -f2 | xargs -n1 -I {} kill -9 {} ; }' | addToFile
echo 'top-search() { top -c -p $(pgrep -d"," -f "$1") ; }' | addToFile
echo 'search-files () { key="$1" ; grep -rnli . -e "$key" ; }' | addToFile
echo 'dockerExecute () { query="$1"; shift; sudo docker exec $( sudo docker container ls | grep "$query" | cut -d" " -f1 ) $@ }' | addToFile


grep -qxF 'filterByRegex()' "${1:-${BASHFILE}}" || echo 'filterByRegex() { while read line; do echo "$line" | grep -oE "$1" | sed -E "s/$1/\\1/g"; done ; }' >> "${1:-${BASHFILE}}"
