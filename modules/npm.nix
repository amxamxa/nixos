# npm.nix
{ config, pkgs, ... }:
{
# Install npm via nodejs package
  environment.systemPackages = with pkgs; [
    # Event-driven I/O framework for the V8 JavaScript engine
    nodePackages_latest.nodejs  # nodejs_24
    # includes npm, adjust version as needed (nodejs_20, nodejs_18, etc.)
  ];

  # Environment variables for XDG compliance
  environment.variables = {
    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
    npm_config_userconfig = "$XDG_CONFIG_HOME/npm/npmrc";
    npm_config_cache = "$XDG_CACHE_HOME/npm";
    npm_config_prefix = "$XDG_DATA_HOME/npm";
    PATH = [ "$XDG_DATA_HOME/npm/bin" ];
  };
        
programs.npm.package = pkgs.nodePackages.npm;
programs.npm.enable = true;
programs.npm.npmrc = ''
  prefix=${pkgs.getEnv "XDG_DATA_HOME"}/npm
  cache=${pkgs.getEnv "XDG_CACHE_HOME"}/npm
  init-module=${pkgs.getEnv "XDG_CONFIG_HOME"}/npm/config/npm-init.js
  init-license=MIT
  init-author-url=https://www.npmjs.com/
  color=true

  save-exact=true  # Speichert exakte Versionen in package.json
  audit=true       # Führt Sicherheitsaudits durch
  strict-ssl=false  # Nur, wenn selbstsignierte Zertifikate verwendet werden
  loglevel=warn
  progress=true # Fortschrittsbalken
  # Performance
  fetch-retries=3
  fetch-retry-mintimeout=10000
  fetch-retry-maxtimeout=60000
  '';

 system.activationScripts.npmDirs = ''
    mkdir -p "$XDG_CONFIG_HOME/npm"
    mkdir -p "$XDG_CACHE_HOME/npm"
    mkdir -p "$XDG_DATA_HOME/npm"
    chown -R amxamxa:mxx max:users "$XDG_CONFIG_HOME/npm"
    chown -R ''${USER}:mxx "$XDG_CACHE_HOME/npm"
    chown -R ''${USER}:mxx "$XDG_DATA_HOME/npm"
  '';
}


# nixOS curl -fsSL https://claude.ai/install.sh | bash
### troubleshooting von npm
/*
```sh
# Sollte die installierte Version ausgeben. Falls nicht, ist npm nicht korrekt installiert oder im `PATH` verfügbar.
npm --version

# Testet, ob globale Installationen funktionieren. 
npm install -g lodash
# Prüfe danach:
ls ~/.local/share/npm/bin  # oder $XDG_DATA_HOME/npm/bin`  
```
#### Häufige Probleme

##### a) **Permissions (Rechteprobleme)**
- **Symptom:** `EACCES`-Fehler bei globalen Installationen.
Lösung:
- Stelle sicher, dass die XDG-Verzeichnisse existieren und korrekte Berechtigungen haben:
     `ls -ld $XDG_DATA_HOME/npm $XDG_CACHE_HOME/npm $XDG_CONFIG_HOME/npm`
- Falls nicht, manuell anlegen:
     `mkdir -p $XDG_DATA_HOME/npm $XDG_CACHE_HOME/npm $XDG_CONFIG_HOME/npm chown -R $USER:users $XDG_DATA_HOME/npm $XDG_CACHE_HOME/npm $XDG_CONFIG_HOME/npm`       

##### b) **Cache-Probleme**
- **Symptom:** Langsame Installation oder Fehler bei Paketen.
- **Lösung:**
    - Cache leeren:
 `npm cache clean --force`
   
- Cache-Verzeichnis prüfen:
 `ls -la $XDG_CACHE_HOME/npm`
##### c) **Konfiguration prüfen**
- `npm config list`
  Prüfe, ob `prefix`, `cache` und andere Pfade korrekt auf XDG-Verzeichnisse zeigen.
 
- **Manuelle Korrektur:** Falls Pfade falsch sind, in `~/.config/npm/npmrc` oder `/etc/npm/npmrc` anpassen:
    prefix=$XDG_DATA_HOME/npm cache=$XDG_CACHE_HOME/npm` 

- Testen, ob Registry erreichbar ist:
 `curl -v https://registry.npmjs.org`

#### 3. **Debugging-Tools**
- **Log-Level erhöhen:**
 `npm --loglevel verbose install <paket>`
   
    Gibt detaillierte Logs aus, um Fehlerquellen zu identifizieren.
  **Temporäres Verzeichnis prüfen:**
 echo $TMPDIR`

Falls nicht gesetzt, kann dies zu Problemen führen. Temporär setzen:
- `export TMPDIR=/tmp`
 *Node.js- und npm-Kompatibilität prüfen:**
   
 `node --version npm --version`
    Stelle sicher, dass die Versionen zueinander passen (z. B. Node.js 20.x mit npm 10.x).
    

---

#### 4. **NixOS-spezifische Hinweise**

- **Node.js-Version wechseln:** In `configuration.nix` die gewünschte Version angeben:
    

`environment.systemPackages = with pkgs; [ nodejs_20 ];`

Danach neu bauen:
 `sudo nixos-rebuild switch`
 **Umgebungsvariablen prüfen:**
 `nix-shell -p nodejs_20 --run "env | grep npm"`
 Zeigt, ob die XDG-Variablen korrekt gesetzt sind.
   
*/

