# NixOS Configuration — Modular, Flake‑free, Homemgr-free Production‑ready

This configuration provides a stable, declarative setup that is flexible and works without additional tools!

This repository contains my `configuration.nix` and module files for a standard NixOS desktop PC.

I am a strong advocate of the distribution's declarative configuration approach. Therefore, this setup does **not** use Flakes or Home Manager.


https://img.shields.io/badge/License-MIT-yellow.svg
https://img.shields.io/badge/NixOS-24.05-blue

This repository contains a **comprehensive, modular NixOS configuration** that powers a daily‑driven desktop environment. It demonstrates **Nix best practices without relying on Flakes**, while still being easily portable to a flake‑based setup.

> **Why no Flakes?**
> The configuration was started before Flakes became stable and remains  entirely compatible with the classic NixOS approach. Every module is  self‑contained, making a future migration trivial.
---

### ℹ️ System Information

*   **Version:** NixOS 25.11
*   **Architecture:** x86_64-linux
*   **Multi-User:** Yes
*   **Nix Version:** nix-env (Nix) 2.18.8
*   **Channels (root):** `nixos-24.05`, `nixos-unstable`, `nixpkgs`
*   **Nixpkgs Path:** `/nix/var/nix/profiles/per-user/root/channels/nixos`

---

### ⚙️ Environment

*   **No Flakes**
*   **No Home Manager**
*   **Desktop:** Cinnamon, Xorg, LightDM
*   **Shell:** Zsh
*   **GPU Driver:** NVIDIA proprietary (GeForce GTX 960)
*   **Additional Tools:** Docker

------

## ✨ Highlights

- **Fully modular** – each functional area lives in its own file under `./modules/`
- **COSMIC desktop** on Wayland – modern, fast, and stable
- **PipeWire audio** with low‑latency tuning, JACK emulation, and Bluetooth enhancements
- **Centralized logging** via journald + rich CLI tools (`lnav`, `ccze`, `multitail`, `glogg`)
- **XDG Base Directory compliance** – all applications respect `~/.config`, `~/.local/share`, etc.
- **Smart shell environments** – Zsh + Bash with syntax highlighting, auto‑suggestions, powerlevel10k, and fzf integration
- **Custom color‑env module** – auto‑detects terminal truecolor support and exports 30+ RGB/256‑color variables
- **Declarative user management** with hashed passwords, groups, and passwordless sudo for selected commands
- **Fonts** – dozens of Nerd Fonts, perfect for terminals and coding
- **NetworkManager** with privacy‑focused DNS servers
- **Ad‑blocking** via `/etc/hosts` (Spotify ads blocked by default)
- **Python, Node.js, Docker** environments prepared with XDG compliance and nix‑ld for foreign binaries

------

## 📁 Repository Structure

text

```
.
├── configuration.nix          # Main entry point
├── hardware-configuration.nix # Auto‑generated hardware config (not tracked)
├── modules/
│   ├── audio.nix              # PipeWire, JACK, Bluetooth, volume service
│   ├── bash.nix              # Bash interactive configuration
│   ├── boot.nix              # Bootloader (systemd‑boot), kernel params, microcode
│   ├── color-env.nix         # Custom module: terminal color detection & export
│   ├── cosmic.nix            # COSMIC desktop, greeter, excluded packages
│   ├── docker.nix            # Rootless Docker + helper tools
│   ├── enviroment.nix        # System‑wide env vars, XDG, activation scripts
│   ├── fonts.nix             # Nerd Fonts + fontconfig tuning
│   ├── logs.nix              # Central journald + logrotate + monitoring tools
│   ├── npm.nix              # Node.js/npm with XDG dirs
│   ├── packages.nix         # General system packages (categorized)
│   ├── python.nix           # Python 3.12 + scientific/audio packages + nix‑ld
│   ├── shell-colors.nix     # Custom module: /etc/shell-colors.sh (deprecated? superseded by color-env)
│   ├── user-n-permissions.nix # Users, groups, sudo, activation permissions
│   ├── zsh.nix              # Zsh main config: ZDOTDIR, plugins, prompt, fzf, aliases
│   └── read-only/           # Legacy / third‑party modules (adBloxx, tuxpaint)
│       ├── adBloxx.nix      # 900+ Spotify ad domains in networking.extraHosts
│       └── tuxpaint.nix     # Tuxpaint wrapper with declarative directories
└── README.md (this file)
```



------

## 🧠 Best Practices Demonstrated

This configuration adheres to widely accepted Nix/NixOS best practices – even without Flakes.

| Practice                                     | Implementation                                               |
| -------------------------------------------- | ------------------------------------------------------------ |
| **Modular imports**                          | `imports = [ ./modules/... ]`; each module handles one concern. |
| **Declarative user/group management**        | `users.mutableUsers = false`; `users.users.*` with hashed passwords. |
| **Idempotent activation scripts**            | `system.activationScripts` – only create dirs, symlinks, set permissions once. |
| **Correct scoping of environment variables** | `environment.variables` (build‑time) vs `environment.sessionVariables` (runtime). |
| **XDG Base Directory compliance**            | `environment.sessionVariables` set `XDG_*`; `systemd.user.tmpfiles.rules` creates dirs. |
| **Conditional configuration**                | `lib.mkIf` and `lib.mkForce` used throughout (e.g., TLP vs power‑profiles). |
| **Centralized logging**                      | journald with retention, compression; custom `/var/log/nixos/`; `services.logrotate`. |
| **Nix‑LD for foreign binaries**              | `programs.nix-ld` with a curated library list (`python.nix`). |
| **Fonts and icons reachable system‑wide**    | `environment.pathsToLink = [ "/share/icons" "/share/zsh" ...]`. |
| **Custom NixOS options**                     | `programs.shellColors` and `programs.colorEnv` provide toggles and configuration. |
| **Smart package grouping**                   | Shell‑specific packages in `zsh.nix`/`bash.nix`, desktop apps in `cosmic.nix`, etc. |
| **No mutation of `/etc` outside of Nix**     | Everything is generated from the Nix store; `mutableUsers = false`. |
| **Well‑commented code**                      | Every module explains its purpose, trade‑offs, and debugging commands. |
| **Insecure / unfree package handling**       | Explicit `allowUnfreePredicate` and `permittedInsecurePackages` in `packages.nix`. |

------

## 🚀 Getting Started

###  Clone the repository

```sh
git clone https://github.com/amxamxa/nixos /etc/nixos

# Aktualisiere dein System:
sudo nixos-rebuild switch --show-trace --upgrade --profile-name "amxamxa-github" -I nixos-config=/etc/nixos/configuration.nix
```


