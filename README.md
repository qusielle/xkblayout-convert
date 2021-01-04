xkblayout-convert
=================
A keyboard layout converter of a typed text between English (US) and Russian.
Can be useful when the text is written in the wrong layout to convert it to the
correct one, e.g.:
    
    Руддщ   -(select the text and press shortcut)->  Hello
    Ghbdtn                                           Привет

This script mostly repeats the keyboard switch behaviour of the `Punto Switcher`
utility.

Requirements
------------
* `xdotool`
* [`xkblayout-state`](https://github.com/nonpop/xkblayout-state)
* [`xkb-switch`](https://github.com/grwlf/xkb-switch)

`xkblayout-state` and `xkb-switch` have to be available under the PATH.  
Tested mostly on Xubuntu 20.04 LTS with XIM keyboard input method system
(usually it is a default).


Installation
------------
### Automatically by using `make`
* Make sure that `make` and `docker` are available on your machine:
  `sudo apt-get install docker.io make`
* Run `make install`

Shortcuts setup after install:

| Shortcut          | Command                      |
| ----------------- | ---------------------------- |
| `Pause`           | [`xkblayout-convert word`](#xkblayout-convert-word)     |
| `Shift+Alt+Pause` | [`xkblayout-convert line`](#xkblayout-convert-line)     |
| `Shift+Pause`     | [`xkblayout-convert selected`](#xkblayout-convert-selected) |


### Manually
* Install requirements.
* Create an application keyboard shortcut to call file `xkblayout-convert.sh`
  with needed argument (see the [arguments list](#Arguments-and-usage-scenarios)
  below). You can do it in GUI preferences or by the following command:
  ```bash
  # On XFCE:
  xfconf-query -n -c xfce4-keyboard-shortcuts -p '/commands/custom/<Shift>Pause' -t string -s 'xkblayout-convert selected'
  ```
  This will bind `Shift+Pause` to call
  [`xkblayout-convert selected`](#xkblayout-convert-selected).


Arguments and usage scenarios
-----------------------------
### `xkblayout-convert selected`
Converts the already selected text.  
So when you have typed a text in a wrong layout, select the text and press the
keyboard shortcut you have set up to call the script with `selected` argument.
After a small delay (which is given to let you release all keys pressed) it will
convert the selected text to an opposite layout (`us->ru`, `ru->us`) and switch
a keyboard layout. The source text is copied by emulating `Ctrl+Insert` press
and then being read from the clipboard.
Characters that are not under source keyboard layout are copied without any
change.

### `xkblayout-convert word`
Converts the word before the cursor.  
Selecting is done by emulating `Ctrl+Shift+Left` press.

### `xkblayout-convert line`
Converts all words before the cursor in current line.  
Selecting is done by emulating `Shift+Home` press.


Upstream
--------
<https://github.com/qusielle/xkblayout-convert>

License
-------
The source code is licensed under the MIT license, which you can find in the
[LICENSE](LICENSE) file.
