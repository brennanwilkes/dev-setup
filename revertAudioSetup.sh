pactl list short modules | grep Virtual | tr '\t' ' ' | cut -d' ' -f1 | xargs -n1 pactl unload-module
