# NixOS on Dell XPS 13

Available combinations are:
* [Wayland + sway on XPS 13 9310](https://github.com/ymatsiuk/nixos-config/tree/main) (my current active setup)
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
```
3. Edit `/mnt/etc/nixos/users.nix` to adjust user. Use the following command for password hash `nix-shell -p mkpasswd --run "mkpasswd -m sha-512"`
4. Edit file systems config and luks device
```
nixos-generate-config --root /mnt --show-hardware-config
lsblk -f
```
5. [Enable flakes](https://nixos.wiki/wiki/Flakes#Enable_flakes)
6. Install NixOS
```
nixos-install --flake path:.#nixps
```

## Details

What's inside:
1. NixOS:
    * latest stable kernel from `nixpkgs-small`
    * stable `nix`
    * modules:
      * `podman`
      * `docker` (buildkit enabled)
      * `fonts` (Iosevka, Source Sans Pro, Source Serif Pro)
      * `greetd` (tuigreet)
      * `pipewire`
      * `xdg-portal` (screen sharing)
      * `zsh`

2. Home-Manager:
    * `alacritty` (gruvbox theme)
    * `firefox` with Wayland support
    * `foot` main terminal (gruvbox theme)
    * `gammastep`
    * `git` (`rbw` credentials helper)
    * `gtk` (gruvbox theme)
    * `i3status-rust` (gruvbox theme)
    * `kanshi` (switches to external output once connected)
    * `mako` (gruvbox theme)
    * `neovim` (gruvbox theme + lsp)
    * `starship` (as shell prompt)
    * `sway` (gruvbox theme)
    * `rbw`
    * `fuzzel` application launcher for Wayland
    * `wezterm` (gruvbox theme)


## Upcoming refactoring

Current directory and flake structure doesn't scale. I have to host my work
configuration for mbp in a separate private repository - not ideal.
The goal of refactoring is to modularize the configuration better to allow
different architectures and centralize host management merging both repos.
Proposed structure:

```
nixos/
├── flake.nix
├── flake.lock
├── hosts/
│   ├── nixps/
│   │   └── default.nix
│   ├── nixlab/
│   │   └── default.nix
│   ├── nixpi3/
│   │   └── default.nix
│   ├── nixpi4/
│   │   └── default.nix
│   └── mbp/
│       └── default.nix
├── modules/
│   ├── common/
│   │   ├── boot.nix
│   │   ├── dev-shells.nix
│   │   ├── networking.nix
│   │   ├── users.nix
│   │   └── packages.nix
│   ├── darwin/
│   │   ├── aerospace.nix
│   │   ├── homebrew.nix
│   │   ├── jankyborders.nix
│   │   └── defaults.nix
│   └── linux/
│       ├── apfs.nix
│       ├── greetd.nix
│       ├── home-assistant.nix
│       ├── obs.nix
│       ├── opengl.nix
│       ├── pipewire.nix
│       ├── tailscale.nix
│       ├── telegraf.nix
│       ├── upgrade-diff.nix
│       ├── zigbee2mqtt.nix
│       └── fonts.nix
└── home/
    ├── darwin/
    │   └── i3status-rust.nix
    ├── linux/
    │   ├── foot.nix
    │   ├── gammastep.nix
    │   ├── gtk.nix
    │   ├── i3status-rust.nix
    │   ├── kanshi.nix
    │   ├── mako.nix
    │   └── sway.nix
    ├── common/
    │   ├── alacritty.nix
    │   ├── firefox.nix
    │   ├── gammastep.nix
    │   ├── git.nix
    │   ├── gtk.nix
    │   ├── mcfly.nix
    │   ├── neovim.nix
    │   ├── rbw.nix
    │   ├── starship.nix
    │   ├── wezterm.nix
    │   └── zoxide.nix
    ├── nixps.nix
    ├── nixlab.nix
    ├── nixpi3.nix
    ├── nixpi4.nix
    └── mbp.nix
```

Notes:
* `default.nix` looks redundant, `hosts/nixps.nix` instead of `hosts/nixps/default.nix`
* `home/` split into `linux` and `darwin`, maybe `graphics|gui` and `terminal|cli` (?)
* import modules/hm in `flake.nix` per host or chain imports `flake.nix -> hosts/nixps/default.nix -> modules/common/boot.nix ...`
* does `modules/common` make sense even
