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
convert_selected() {
    local from to new_layout
    local -r current_layout=$(xkblayout-state print '%n')
    case $current_layout in
        English) from=$en_layout; to=$ru_layout; new_layout='ru';;
        Russian) from=$ru_layout; to=$en_layout; new_layout='us';;
        \?) return 1;;
    esac

    xdotool key ctrl+Insert
    local -r clipboard_text=$(xclip -o)
    local -r translated_text=$(sed -e "y/$from/$to/" <<<"$clipboard_text")
    xdotool type "$translated_text"
    xkb-switch -s "$new_layout"
}


convert_word() {
    xdotool key ctrl+shift+Left
    convert_selected
}


convert_line() {
    xdotool key shift+Home
    convert_selected
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

    if [[ $# -gt 1 ]]; then
        print_help >&2
        return 1
    fi

    case $arg in
        help|--help|h) print_help;;
        line|selected|word) wait_for_keys_released; convert_$arg;;
        \?) print_help >&2; return 1;;
    esac
}

main "$@"
