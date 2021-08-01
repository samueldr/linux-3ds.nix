Linux-3DS.nix
=============

What's this??
-------------

This is a Nix-based packaging for [linux-3ds](https://github.com/linux-3ds), a
port of Linux for the 3DS family of devices.

For the time being, and for the foreseeable future, this is only mean to build
a toy system (kernel and initramfs) as a demo. This is a neat showcase of how
one can leverage Nixpkgs and Nix in parts to build an embedded style system.

This **has no real use**.


How do I use this?
------------------

Generally speaking, you probably wouldn't. Additionally, this does not list the
steps required for *hacking your 3DS*. I'm assuming `luma` is the payload used
and already installed.

If you want to, still, first build `sdcard-filesystem`, which is the
partial skeleton structure to copy to your SD card,

```
 $ env -i nix-build -A sdcard-filesystem
```

And *somehow* copy this to your SD card. (Read the tips section.)

Then, when the 3DS boots, holds `[START]`. This will show the *Luma3DS
chainloader* interface. Select `firm_linux_loader` and launch it.

The display will glitch out a bit for a few seconds, then the top panel will
show the console logs, and the bottom panel a basic on-screen-keyboard.

*Have fun!*


Tips
----

### Easier rebooting from 3DS menu

Hold `[L] + [SELECT]` then press `[DPAD Down]`

Then you can choose *Reboot* and hold `[START]`.

### Copying result

Use `./ftp.sh <ip address:port>` to copy to your 3DS, assuming it is
running an FTP server.
