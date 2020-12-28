#!/usr/bin/env bash
set -e

en_layout='qwertyuiop[]\\asdfghjkl;'\''zxcvbnm,.\/~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?~`'
ru_layout='йцукенгшщзхъ\\фывапролджэячсмитьбю.Ё!"№;%:?*()_+ЙЦУКЕНГШЩЗХЪ\/ФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,Ёё'

xdotool key ctrl+Insert
clipboard_text=$(xclip -o)

current_layout=$(xkblayout-state print '%n')

# Since `xdotool type` is affected by pressed key modificators (e.g. Shift),
# do sleep for a while to let user release the keys were used to trigger this
# script.
# `--clearmodifiers` argument to `xdotool` often inverts the modificator key
# status in the end depending on when the key was released, so nothing better
# than stable `sleep`.
sleep 0.5

if [[ $current_layout == English ]]; then
    translated_text=$(sed -e "y/$en_layout/$ru_layout/" <<<"$clipboard_text")
    xdotool type "$translated_text"
    xkb-switch -s ru
elif [[ $current_layout == Russian ]]; then
    translated_text=$(sed -e "y/$ru_layout/$en_layout/" <<<"$clipboard_text")
    xdotool type "$translated_text"
    xkb-switch -s us
fi
