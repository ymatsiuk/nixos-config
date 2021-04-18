# NixOS on Dell XPS 13

Available combinations are:
* [Wayland + sway on XPS 13 9310](https://github.com/ymatsiuk/nixos-config/tree/xps13/9310%2Fsway) (my current active setup)
* [Xorg + i3 on XPS 13 9310](https://github.com/ymatsiuk/nixos-config/tree/xps13/9310%2Fi3)
* [Wayland + sway on XPS 13 9370](https://github.com/ymatsiuk/nixos-config/tree/xps13/9370%2Fsway)
* [Xorg + i3 on XPS 13 9370](https://github.com/ymatsiuk/nixos-config/tree/xps13/9370%2Fi3)

9370 configuration is not supported anymore as I don't own this device.
The branches preserved only for historical purpose.
`9310/sway` is my daily driver (Xorg is no longer supported and left for potential
fallback in case of urgent need or annoying behavior, that I'm now thinking about
will not likely be the case)

## Installation

1. Boot from **NixOS** live USB preferably
```
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
parted /dev/nvme0n1 -- set 1 boot on
parted /dev/nvme0n1 -- mkpart primary 512MiB 100%
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup luksOpen /dev/nvme0n1p2 luks
pvcreate /dev/mapper/luks
vgcreate xps /dev/mapper/luks
lvcreate -L 16G xps -n swap
lvcreate -l 100%FREE xps -n nixos
sudo mkfs.fat -F 32 -n boot /dev/nvme0n1p1
sudo mkfs.ext4 -L nixos /dev/xps/nixos
sudo mkswap -L swap /dev/xps/swap
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/xps/swap
```
2. Get the configuration
```
git clone https://github.com/ymatsiuk/nixos-config /mnt/etc/nixos/
nixos-generate-config --root /mnt
```
3. Edit `/mnt/etc/nixos/users.nix` to adjust user. Use the following command for password hash `nix-shell -p mkpasswd --run "mkpasswd -m sha-512"`
4. Add home-manager and switch to `<nixos-unstable>`
```
#if we booted not unstable iso
nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```
5. Install NixOS
```
nixos-install
```

## Details

What's inside:
1. NixOS:
    * latest available kernel
    * latest `nix` with `flakes` support #TODO: migrate to flakes
    * custom overlays:
      * [howdy](https://github.com/NixOS/nixpkgs/issues/76928#issuecomment-733990484)
      * `teleport-ent`
    * modules:
      * `appgate-sdp` proprietary VPN client
      * `docker`
      * `fonts` (Iosevka, Source Sans Pro, Source Serif Pro)
      * `fprintd` (TOD support + Goodix driver)
      * `greetd` (tuigreet)
      * `neovim` (gruvbox theme)
      * `pipewire`
      * `xdg-portal` for sharing the screen under Wayland

2. Home-Manager:
    * `alacritty` (gruvbox theme)
    * `chromium` with extensions and Wayland/Pipewire support
    * `dmenu-wl` might be replaced with `rofi` in future
    * `firefox` with Wayland support
    * `gammastep`
    * `git` includes extension for signing keys
    * `gtk` #TODO: add gruvbox theme
    * `i3status-rust` (gruvbox theme + toggle to switch between HFP/A2DP)
    * `mako` (gruvbox theme)
    * `mpris-proxy` for WH-1000XM3 media buttons support
    * `mpv`
    * `qutebrowser`
    * `starship`
    * `sway` (gruvbox theme)
    * `zsh` (zplug for plugins)
