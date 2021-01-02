#!/usr/bin/env bash
set -e

en_layout='qwertyuiop[]\\asdfghjkl;'\''zxcvbnm,.\/~!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?~`'
ru_layout='йцукенгшщзхъ\\фывапролджэячсмитьбю.Ё!"№;%:?*()_+ЙЦУКЕНГШЩЗХЪ\/ФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,Ёё'


# Wait until keyboard keys pressed by user are released.
#
# This is needed since the typing of target text by `xdotool type` is affected
# by pressed modificators, so let user release the keys were used to trigger
# this script. For example, if `Shift` button is pressed, then target lowercase
# text will be typed in uppercase and vice versa.
#
# Note: `--clearmodifiers` argument to `xdotool` often inverts the modificator
# key status in the end depending on when the key was released, so it was
# decided not to use that.
wait_for_keys_released() {
    # TODO: Find the proper way to detect that keys are released. All found
    #       solutions require superuser rights, which is not applicable here.
    sleep 0.5
}


# Convert text that is already selected.
#
# Proceed in the following steps:
# * Copy text to clipboard by pressing `ctrl+Insert`.
# * Detect current layout.
# * Translate characters from current layout to opposite.
# * Type converted text.
# * Switch keyboard layout to opposite.
convert_selected_text() {
    xdotool key ctrl+Insert
    local -r clipboard_text=$(xclip -o)
    local -r current_layout=$(xkblayout-state print '%n')

    local translated_text
    if [[ $current_layout == English ]]; then
        translated_text=$(sed -e "y/$en_layout/$ru_layout/" <<<"$clipboard_text")
        xdotool type "$translated_text"
        xkb-switch -s ru
    elif [[ $current_layout == Russian ]]; then
        translated_text=$(sed -e "y/$ru_layout/$en_layout/" <<<"$clipboard_text")
        xdotool type "$translated_text"
        xkb-switch -s us
    fi
}

main() {
    wait_for_keys_released
    convert_selected_text
}

main
