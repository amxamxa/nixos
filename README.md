# 🖥️ NixOS Desktop Configuration

This configuration provides a stable, declarative setup that is flexible and works without additional tools!

This repository contains my `configuration.nix` and module files for a standard NixOS desktop PC.

I am a strong advocate of the distribution's declarative configuration approach. Therefore, this setup does **not** use Flakes or Home Manager.

---

### ℹ️ System Information

*   **Version:** NixOS 24.05
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

---

### 📁 Directory Structure & File Status

| File/Directory | Status |
| :--- | :--- |
| `AdBloxx.nix` | ✅ OK |
| `audio.nix` | ✅ OK |
| `boot.nix` | ✅ OK |
| `configuration.nix` | ✅ OK |
| `docker.nix` | ✅ OK |
| `firefox.nix` | 📝 TODO |
| `gpu.nix` | 🗑️ Obsolete |
| `hardware-configuration.nix` | ✅ OK |
| `packages.nix` | ✅ OK |
| `users.nix` | ✅ OK |
| `README.md` | ✅ OK |
| `zsh.nix` | ✅ OK |
| `costum-pkgs/lightdm-settings.nix` | ❌ NOK |
| `costum-pkgs/README.md` | ❌ NOK |
| `costum-pkgs/suru-plus.nix` | ❌ NOK |

---

### ✨ Key Features

This project focuses on a stable, declarative configuration that is flexible and works without additional tools:

*   **No Flakes** or **Home Manager**.
*   Purely **declarative system configuration**.

**Features:**

*   A minimalist and powerful environment with Cinnamon and Docker.
*   Proprietary NVIDIA driver for GPU support.

---

### 🚀 Installation

1.  **Clone this repository:**
    ```bash
    git clone https://github.com/amxamxa/nixos/
    ```

2.  **Copy the files to your NixOS directory:**
    ```bash
    cp -rvi . /etc/nixos
    ```

3.  **Rebuild and update your system:**
    ```bash
    sudo nixos-rebuild switch --show-trace --upgrade --profile-name "amxamxa-github" -I nixos-config=/etc/nixos/configuration.nix
    ```
    ---
    

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
| `AdBloxx.nix`    		             | OK     |
| `audio.nix`    		             | OK     |
| `boot.nix`    		             | OK     |
| `configuration.nix`                | OK     |
| `docker.nix`                       | OK     |
| `firefox.nix`                      | TODO   |
| `gpu.nix`                          | obsolet|
| `hardware-configuration.nix`       | OK     |
| `packages.nix`                     | OK     |
| `users.nix`                        | OK     |
| `README.md`                        | OK     |
| `zsh.nix`                          | OK     |
| `costum-pkgs/lightdm-settings.nix` | NOK    |
| `costum-pkgs/README.md`            | NOK    |
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


