xkblayout-convert
=================
A keyboard layout converter of a selected text between English (US) and Russian.
Can be useful when the text is written in the wrong layout to convert it to the
correct one, e.g.:
    
    Руддщ   -(select the text and press shortcut)->  Hello
    Ghbdtn                                           Привет

This script mostly repeats the `Shift+PrtSc` behaviour of `Punto Switcher`
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
* Create an application keyboard shortcut to call application
  `xkblayout-convert` without arguments.


### Manually
* Install requirements.
* Create an application keyboard shortcut to call file `xkblayout-convert.sh`
  without arguments.


Usage scenario
--------------
When you have typed a text in a wrong layout, select the text and press the
keyboard shortcut you have set up to call the `xkblayout-convert` script.
After a small delay (which is given to let you release all keys pressed) it will
convert the selected text to an opposite layout (`us->ru`, `ru->us`) and switch
a keyboard layout.
Characters that are not under source keyboard layout are copied without any
change.


Upstream
--------
<https://github.com/qusielle/xkblayout-convert>

License
-------
The source code is licensed under the MIT license, which you can find in the
[LICENSE](LICENSE) file.
