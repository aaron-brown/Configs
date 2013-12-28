#! /bin/bash

### Personal environment variables

### Path definitions.

LOCALBIN="${HOME}/.bin"
PATH="${PATH}:${LOCALBIN}"

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        export TERM='xterm-color'
fi
