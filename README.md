# NixOS Desktop Configuration

**Diese Konfig supported eine stabile, deklarative Konfiguration, die flexibel und ohne zusätzliche Tools funktioniert!** 

Hier sind meine Konfigurationsdateien `configuration.nix + modules` für einen `average` Desktop-PC mit NixOS. 

Ich stehe total auf die deklarativen Konfiguration der Distribution. Daher gibt es hier kein Flakes oder Home-Manager.

## Systeminformationen

```
Version: nixOS 24.05  
Architektur: x86_64-linux  
Multi-User: Ja  
Nix-Version: nix-env (Nix) 2.18.8  
Kanäle (root): nixos-24.05, nixos-unstable, nixpkgs  
Nixpkgs-Pfad: /nix/var/nix/profiles/per-user/root/channels/nixos  
```

## env / Umgebung

- **Ohne Flakes**
- **Ohne Home-Manager**
- Desktop: **Cinnamon**, **xorg**, **lightDM**
- Shell: **zsh**
- GPU-Treiber: **NVIDIA proprietär (GeForce GTX 960)**
- Zusätzliche Tools: **Docker**

## Verzeichnisstruktur und Status der Dateien

| Verzeichnis/Datei                  | Status |
| ---------------------------------- | ------ |
| `configuration.nix`                | OK     |
| `docker.nix`                       | OK     |
| `firefox.nix`                      | TODO   |
| `gpu.nix`                          | OK     |
| `hardware-configuration.nix`       | OK     |
| `packages.nix`                     | OK     |
| `users.nix`                        | OK     |
| `README.md`                        | OK     |
| `zsh.nix`                          | OK     |
| `costum-pkgs/lightdm-settings.nix` | OK     |
| `costum-pkgs/README.md`            | OK     |
| `costum-pkgs/suru-plus.nix`        | NOK    |

## Besonderheiten

Dieses Projekt konzentriert sich auf eine stabile, deklarative Konfiguration,  die flexibel und ohne zusätzliche Tools funktioniert:

- **ohne Flakes**, 
- **Home-Manager**,  
- **rein deklarative Konfiguration**

**Features:**

- Eine minimalistische und leistungsstarke `env` mit Cinnamon und Docker.
- Proprietärer NVIDIA-Treiber für die GPU.

## Installation

```sh
# Klone dieses Repository:
git clone https://github.com/amxamxa/nixos/

# Kopiere die Files ins NixOS-Verzeichnis:
cp -rvi . /etc/nixos  

# Aktualisiere dein System:
sudo nixos-rebuild switch --show-trace --upgrade --profile-name "amxamxa-github" -I nixos-config=/etc/nixos/configuration.nix
```


