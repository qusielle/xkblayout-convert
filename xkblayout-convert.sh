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


convert_current_word() {
    xdotool key ctrl+shift+Left
    convert_selected_text
}


convert_current_line() {
    xdotool key shift+Home
    convert_selected_text
}


# Print the usage information message.
print_help() {
    echo -ne "Russian <-> English (US) Keyboard layout switcher for the text in the input field.

Usage:
  $0 (line|selected|word|help|--help|-h)

Arguments:
  line              Convert all words on the line before the cursor.
  selected          Convert selected text.
  word              Convert a word before the cursor.
  help|--help|-h    Print this help message.
"
}


main() {
    local -r arg=$1
    local function_to_run

    if [[ $arg == 'line' ]]; then
        function_to_run='convert_current_line'
    elif [[ $arg == 'selected' ]]; then
        function_to_run='convert_selected_text'
    elif [[ $arg == 'word' ]]; then
        function_to_run='convert_current_word'
    elif [[ $arg == 'help' ]] || [[ $arg == '--help' ]] || [[ $arg == '-h' ]]; then
        print_help
        return
    else
        print_help >&2
        exit 1
    fi

    wait_for_keys_released
    $function_to_run
}

main "$1"
