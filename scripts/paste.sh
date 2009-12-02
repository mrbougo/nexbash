#!/bin/bash

# This script copies the contents of the clipboard in the _paste cvar.
# depends on xclip

[[ -z $(which xclip) ]] && { echo 'echo ^1xclip not found.'; echo 'echo ^1This script needs xclip to run, please install it.'; exit 1; }
[[ "$1" != "" ]] && { echo 'echo This command doesn'\''t need arguments.'; echo 'echo The paste buffer is just copied into the _paste cvar.'; }

paste=$(xclip -o -sel clip | sed 's/"/\\"/g')

echo "set _paste \"$paste\""
