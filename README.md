# NixOS on Dell XPS 13 (9370)

## Installation

1. Boot from **NixOS** live USB preferrably
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
    * latest hardware support ( `mem_sleep_default=deep` is removed as it's fixed in kernel ) for all available hardware ( bluethooth, video, cpu ) with focus on powersave. There is still potential for tuning, but it works the way I expect it to.
    * docker, pulseaudio, fonts (my main font is Iosevka), neovim (gruvbox + some plugins I use), few system packages I fins useful to have for all users in the system, Xorg with tuned touchpad (libinput), lightDM and i3wm.

2. Home-Manager:
    * alacritty
    * dunst
    * git
    * gtk
    * i3status-rust
    * redshift
    * starship
    * rofi (currently commented out, work in progress)
    * zsh (zplug for plugins)
    * autocutsel to sync clipboard [details](https://specifications.freedesktop.org/clipboards-spec/clipboards-latest.txt) and xclip
    * htop, fzf, gpg, nm-applet, pasystray

What's missing:
  * i3 config is missing so far (yet to decide wether I want it to be managed by hm or not)
