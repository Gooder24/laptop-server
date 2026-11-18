# laptop-server

Run an old laptop as a headless Linux server: the lid does nothing, the machine never sleeps, the display goes
dark after the start and `SUPER + D` or `Ctrl + Alt + D` switches it, charging stops at 80 %, swap lives in compressed memory, the
boot menu does not wait, and `laptop-server check` says whether all of that holds. One Debian package of
systemd settings and one small script; nothing runs in the background.

A laptop is a good small server. It draws 5 to 15 W, makes no noise, has its own keyboard and screen for the
day the network is down, and its battery is an uninterruptible power supply (UPS) that rides out a power cut.
Out of the box it is a bad one: it suspends when the lid closes or when it has been idle, its screen burns all day, and it holds its battery at
100 % on the charger for years, which wears the battery out fastest. This package fixes those, and only those.

Made for [KarchiOS Headless](https://github.com/Gooder24/karchi-os-headless-debian), a Debian 13 install for
laptops that run AI coding agents around the clock; works on any Debian or Ubuntu with systemd.

## What it changes, and why a server wants it

| change | how | why |
|---|---|---|
| **the lid does nothing** | `logind.conf.d`: `HandleLidSwitch*=ignore`, on battery, on power and docked | close it, stack it, put it on a shelf: it keeps serving |
| **the machine never sleeps** | `sleep.conf.d`: `AllowSuspend=no`, hibernation off | not the lid, not an idle timer, not a stray `systemctl suspend`: a suspended server answers nobody |
| **the display is dark, `SUPER + D` or `Ctrl + Alt + D` lights it** | `laptop-server display`, `laptop-server-display-off.service`, a `keyd` binding | the panel and its backlight are the biggest power draw and wear out; when you do stand at the machine, one key gives you the console |
| **charging stops at 80 %** | `charge_control_end_threshold` of every battery, at start and when a battery appears | a lithium battery kept full and warm loses its capacity in a year or two; at 80 % it keeps it, and still covers a power cut |
| **swap in compressed memory** | `systemd-zram-generator`: zstd, half the memory, 4 GB at most | old laptops have little memory; zram stretches it, and no swap partition wears the solid-state drive (SSD) |
| **the boot menu does not wait** | `GRUB_TIMEOUT=0` | after a power cut or a reboot the machine is back in seconds, with nobody to press Enter (`Esc` still shows the menu) |
| **it tells you** | `laptop-server check` | on the console or over SSH: `ok`, `WARN` with what to do, `FAIL` with exit code 1 |

The display is switched off with the console's *forced* blanking (`setterm --blank force`) together with the
backlight (`bl_power`). Writing to `/sys/class/graphics/fb0/blank`, which most guides suggest, is undone by the
first key press. Two more details keep it dark: a udev rule sets it again when a graphics driver takes the
screen over after the start (it turns the screen on), and `getty@tty1` keeps its screen (`TTYVTDisallocate=no`),
because clearing it makes the kernel set the video mode again and light the panel.

## Requirements

- Debian or Ubuntu with systemd. The package depends on `systemd`, `util-linux`, `keyd` and `systemd-zram-generator`.
- To build the package: `make` and `dpkg-deb`.
- Root (`sudo`) to install it, and to change the display, the charge limit or the boot menu.

## Quick start

```sh
make deb                              # builds laptop-server_0.1.0_all.deb; needs make and dpkg-deb
sudo apt install ./laptop-server_*.deb
laptop-server check
```

The lid setting and the charge limit apply at once; the dark display and compressed swap from the next start.
Removing the package turns the display on and gives the lid and sleep back to systemd's defaults; purge also
removes the GNU GRand Unified Bootloader (GRUB) timeout and the `SUPER + D` or `Ctrl + Alt + D` binding.

Other distributions: `make install DESTDIR=…` lays out the files for a package (systemd paths under `/usr`,
settings under `/etc`); then enable `laptop-server-display-off` and `laptop-server-battery`, enable `keyd`, and
run `update-grub` or your distribution's equivalent.

## Commands

```
laptop-server check                         ok / WARN / FAIL for everything above
laptop-server display on|off|toggle|status  the built-in display (root, except status)
laptop-server battery                       BAT0: 64 %, Charging, stops at 80 %
laptop-server battery apply                 set CHARGE_LIMIT now (root)
laptop-server --self-test
```

## Settings

`/etc/laptop-server.conf`:

| setting | default | meaning |
|---|---|---|
| `CHARGE_LIMIT` | 80 | charging stops here; 100 is the factory setting, empty leaves the firmware alone |

After a change: `sudo laptop-server battery apply`.

A limit lower than the battery's charge does not discharge it: on the charger it stays where it is until the
machine runs on battery. Where there is also a start threshold (ThinkPads), it is set 10 points lower, so the
battery is not topped up for every percent it loses.

## Limits

- The charge limit needs the kernel's `charge_control_end_threshold`: ThinkPads, ASUS, Lenovo IdeaPad,
  Huawei, Framework, MSI and some Dell and HP laptops have it. `laptop-server check` warns when a battery has
  none. Some firmware accepts only certain values (some ASUS models: 60, 80 or 100); `check` warns when it
  kept a different one.
- A laptop does not switch itself on after the power has been out long enough to drain the battery; that is up
  to the firmware (look for "Power on AC attach" or "Restore on AC power loss" in its setup).
- The `SUPER + D` or `Ctrl + Alt + D` binding comes from `keyd`, which takes over every keyboard. If you have your own keyd
  configuration for all keyboards (`[ids] *`), add the binding there instead.
- Wi-Fi power saving, network setup and remote access are not part of this package; KarchiOS Headless shows
  one way (iwd, systemd-networkd, Tailscale).

## Tests

`make check` runs the self-test (charge limit with a made-up `/sys`, GRUB's timeout as `update-grub` reads it).
The whole package is tested in KarchiOS Headless's virtual machine (VM) test: a fresh install, two starts with a power
cut in between, the lid and sleep settings as logind reports them, compressed swap, and the screen measured dark after
the start, not lit by an ordinary key, lit and darkened by `SUPER + D` or `Ctrl + Alt + D`. The charge limit is checked on real
laptops (ASUS Vivobook X1504V).

## Similar tools

TLP and `power-profiles-daemon` manage power on laptops you sit at, TLP including charge thresholds; their
defaults are about battery life away from the charger. Guides for "laptop as a server" cover the lid in
`logind.conf`, usually without the rest. This package is the whole set for a laptop that never leaves the
charger and that nobody looks at.

## Accessibility

The output is plain text: every status is a word (`ok`, `WARN`, `FAIL`), and the tool prints no colour. The
accessibility workflow checks the documentation's headings, image alternative text and link text with
`.github/scripts/check-docs.py`. Known limitations and how to report a barrier are in [ACCESSIBILITY.md](ACCESSIBILITY.md).

## License

MIT
