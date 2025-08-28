# /etc/nixos/fonts.nix
{ config, pkgs, ... }:
{
/*
FYI: Zeichenkombinationen wie !=, >=, ==, -> oder := werden durch Ligaturen
in zusammenhängende Symbole umgewandelt (z. B. ≠, ≥, ≡).
"DZ": Dotted Zero  	"CE" auf eine Central European Variante
*/

  # --- 1. Font-Pakete korrekt installieren ---
  fonts.packages = with pkgs; [
      # Monospaced programming fonts patched with Nerd Font symbols
      nerd-fonts._0xproto #   A programming font focused on source code legibility
      nerd-fonts._3270 # Derived from the x3270 font, a modern format of a font with high nostalgic value 
      nerd-fonts.agave # small, monospace, outline font that is geometrically regular and simple 
      nerd-fonts.bigblue-terminal #   Nostalgic, closely based on IBM's 8x14 EGA/VGA charset
  #    nerd-fonts.caskaydia-cove #   A fun, new monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal
      #  small, monospace, outline font that is geometrically regular and simple 
      nerd-fonts.departure-mono #  A monospaced pixel font with a lo-fi, techy vibe 
      nerd-fonts.envy-code-r #   Fully-scalable monospaced font designed for programming and command prompts
    #  nerd-fonts.gohufont #   Bitmap font, tall capitals and ascenders, small serifs 
      nerd-fonts.hack
      nerd-fonts.hurmit #   Symbols stand out from common text
 #     nerd-fonts.iosevka-term #   A narrower variant focusing terminal uses: Arrows and geometric symbols will be narrow to follow typical terminal usages
      nerd-fonts.iosevka-term-slab #   Nice as Iosevka but WITH SERIFs
      nerd-fonts.lekton # very light and thin characters, sharp m's, `0` and `O`
  #    nerd-fonts.monofur # Dotted zeros, slightly exaggerated curvy characters, compact chWSSWWDA@!aracters 
      nerd-fonts.meslo-lg #  Slashed zeros, customized version of Apple's Menl
      nerd-fonts.proggy-clean-tt
      nerd-fonts.tinos
     # nerd-fonts.terminess-ttf
      nerd-fonts.shure-tech-mono #   Dotted zeros, distinguishable 1 and l, curved and straight character lines
      nerd-fonts.symbols-only  # Fallback symbols for patched fonts
    
    # o t h e r   f o n t s 
       tt2020            # Terminal Typewriter 2020 font
      openmoji-color # Open-source emojis for designers, developers and everyone else
      # noto-fonts-emoji  # = Noto Color Emoji
      # unfree  joypixels         # Emoji font
      fira-code # Monospace font with programming ligatures
      fira-code-symbols # FiraCode unicode ligature glyphs in private use area
    #  open-sans         # Sans-serif UI font
      # noto-fonts       # Optionally enable Google's Noto family
      # dejavu_fonts      # Popular fallback serif/sans fonts
    ];

  # --- 2. Allgemeine Schriftarten-Einstellungen ---
  fonts.enableDefaultPackages = false;   # Standard-Schriftarten von NixOS aktivieren
  fonts.enableGhostscriptFonts = true;  # Ghostscript-Schriftarten für PDFs/PostScript einbinden
  fonts.fontDir.enable = true;          # Symlink /run/current-system/sw/share/X11/fonts nach /nix/store

  # --- 3. Fontconfig-Systemkonfiguration ---
  fonts.fontconfig = {
    enable = true;              # Fontconfig systemweit aktivieren
    includeUserConf = false;    # Benutzerspezifische Konfigurationen ignorieren
    useEmbeddedBitmaps = false; # Verbessert die Darstellung auf modernen Displays
    antialias = true;           # Kantenglättung aktivieren
    hinting = {
      enable = true;
      autohint = false;         # Besser, wenn Schriften gutes natives Hinting haben
      style = "full";           # "full", "medium", "slight", "none"
    };
    subpixel = {
      rgba = "rgb";             # Subpixel-Reihenfolge (Standard für die meisten LCDs)
      lcdfilter = "default";    # Filter für Subpixel-Rendering
    };
    
    /*
1. Ablehnung nicht-monospace Nerd Fonts:
        Die erste Regel verwendet <rejectfont>, um alle Schriftarten abzulehnen, die zwar "Nerd Font" im Namen enthalten, aber nicht "Mono". Dies verhindert, dass diese Fonts im Fallback-Prozess verwendet werden25.
        Die compare="contains" und compare="not_contains" Attribute sorgen für die korrekte Filterung.

2. Explizite Erlaubnis für "Nerd Font Mono":
        Die zweite Regel verwendet ein <match>-Element, um alle Schriftarten, die "Nerd Font Mono" im Namen enthalten, explizit zu erlauben und sie dem monospace-Alias zuzuordnen.
        mode="assign_replace" stellt sicher, dass der Fontname durch "monospace" ersetzt wird, was die Konsistenz in Anwendungen erhöht.

3.    Bevorzugte Reihenfolge für monospace Fonts:
        Der <alias>-Block für monospace definiert eine Reihenfolge, in der Fonts bevorzugt werden sollen. 

4.    Ligaturen für Fira Code:
     Viisuellen Verbesserungen für Fira Code zu aktivieren, falls Sie diesen Font verwenden
       
    <rejectfont>

        */
        
localConf = ''
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">

<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<!-- Generated by Font Manager. Do NOT edit this file. -->
<fontconfig>
  <selectfont>
    <rejectfont>
      <pattern>
        <patelt name="family">
          <string>Tinos Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>0xProto Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>3270 Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>0xProto Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>3270 Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>Agave Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>Agave Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>BigBlueTerm437 Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>BigBlueTerm437 Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>BigBlueTermPlus Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>BigBlueTermPlus Nerd Font Mono</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>BigBlueTermPlus Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>DejaVu Sans</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>DepartureMono Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>DepartureMono Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>EnvyCodeR Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>EnvyCodeR Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>Hack Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>Hack Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>Hurmit Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>Hurmit Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>IosevkaTermSlab Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>IosevkaTermSlab Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>Lekton Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>Lekton Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGLDZ Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGL Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGL Nerd Font Mono</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGL Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGMDZ Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGMDZ Nerd Font Mono</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGMDZ Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGM Nerd Font Mono</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGM Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGM Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGSDZ Nerd Font Mono</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGSDZ Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGS Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGS Nerd Font Mono</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGLDZ Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGS NF</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>MesloLGS Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>ProggyClean CE Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>ProggyClean CE Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>ProggyClean Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>ProggyClean Nerd Font Mono</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>ProggyClean Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>ProggyCleanSZ Nerd Font Mono</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>ProggyCleanSZ Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>ShureTechMono Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>ShureTechMono Nerd Font Propo</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>Symbols Nerd Font</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>TT2020 Style F</string>
        </patelt>
      </pattern>
      <pattern>
        <patelt name="family">
          <string>TT2020 Style G</string>
        </patelt>
      </pattern>
    </rejectfont>
  </selectfont>
</fontconfig>
'';


   
   /*  Set default fonts by type 'fonts.fontconfig.localConf" vs.   'fonts.fontconfig.defaultFonts':
  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 Die Konfiguration über die XML-Struktur in localConf ist sehr mächtig, kann aber unübersichtlich werden. 
  Für die einfache Definition von Standard-Schriftarten (wie monospace, serif, sans-serif) bietet NixOS die Option fonts.defaultFonts. Dies erzeugt automatisch die notwendige Fontconfig-Konfiguration und ist oft lesbarer. 
    */
defaultFonts = {
        sansSerif = [ "tt2020" "Open Sans" "DejaVu Sans" "Symbols Nerd Font" ];
        serif =    [ "Tinos Nerd Font" "DejaVu Serif" "Symbols Nerd Font" ];
        emoji =    [ "openmoji-color " ];
        monospace = [    "Envy Code R"
                        "Iosevka Term Slab Nerd Font" 
                         "Hack Nerd Font"
                         "3270 Nerd Font"                    
                         "Agave Nerd Font"
                         "Symbols Nerd Font"
                     ];
     };
};


  # --- 4. Konfiguration für die TTY-Konsole ---
  /*
  
  
      <!-- Optional: Spezifischere Regex-Matching für alle Varianten -->
    <selectfont>
      <rejectfont>
        <pattern>
          <patelt name="family">
            <string>Hack Nerd Font.*</string>
          </patelt>
        </pattern>
      </rejectfont>
    </selectfont>
               <!-- Blockiere alle ZedMono Fonts -->
    <selectfont>
      <rejectfont>
        <pattern>
          <patelt name="family">
            <string>ZedMono Nerd Font.*</string>
          </patelt>
        </pattern>
      </rejectfont>
    </selectfont>

    <!-- Erlaube explizit die gewünschte Variante -->
    <selectfont>
      <acceptfont>
        <pattern>
          <patelt name="family">
            <string>ZedMono Nerd Font Mono,ZedMono NFM:spacing=100:outline=True:scalable=True</string>
          </patelt>
        </pattern>
      </acceptfont>
    </selectfont>
    
      <!-- Blockiere alle Nerd Fonts, die NICHT "Mono" im Namen haben -->
  <selectfont>
    <rejectfont>
      <pattern>
        <patelt name="family">
          <string>.*Nerd Font.*</string>
        </patelt>
      </pattern>
      <!-- Negative Bedingung: Nicht blockieren, wenn "Mono" im Namen -->
      <test name="family" compare="not_contains" qual="any">
        <string>Mono</string>
      </test>
    </rejectfont>
  </selectfont>
  
  console = {
    font = "GohaClassic-16"; # Schriftart für die virtuelle Konsole (TTY)
    # keyMap = "de"; # Bei Bedarf deutsche Tastaturbelegung hier einkommentieren
  }; */
  
}

  


