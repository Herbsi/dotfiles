#!/usr/bin/env sh

port echo requested | sd "(^[\-a-zA-Z0-9_.]+).*" "\$1" | uniq > "$DOTFILES"/ports.txt
