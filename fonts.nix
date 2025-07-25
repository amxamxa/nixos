{ config, pkgs, ... }:
# FYI: Zeichenkombinationen wie !=, >=, ==, -> oder := verwendet. Ligaturen wandeln diese Zeichenfolgen in einzelne, zusammenhängende Symbole um (z. B. ≠, ≥, ≡) 
{
  fonts = {
    # List of explicitly installed font packages
    packages = with pkgs; [
      # Monospaced programming fonts patched with Nerd Font symbols
      nerd-fonts._0xproto # Nerd Fonts: A programming font focused on source code legibility
      nerd-fonts._3270
      nerd-fonts.agave
      nerd-fonts.bigblue-terminal # Nerd Fonts: Nostalgic, closely based on IBM's 8x14 EGA/VGA charset
      nerd-fonts.caskaydia-cove # Nerd Fonts: A fun, new monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal
      nerd-fonts.envy-code-r # Nerd Fonts: Fully-scalable monospaced font designed for programming and command prompts
    nerd-fonts.gohufont # Nerd Fonts: Bitmap font, tall capitals and ascenders, small serifs
          nerd-fonts.hack
          nerd-fonts.hurmit # Nerd Fonts: Symbols stand out from common text
          nerd-fonts.iosevka-term # Nerd Fonts: A narrower variant focusing terminal uses: Arrows and geometric symbols will be narrow to follow typical terminal usages
    nerd-fonts.iosevka-term-slab #Nerd Fonts: Nice as Iosevka but with slab serifs
    nerd-fonts.lekton
      nerd-fonts.monofur
      nerd-fonts.meslo-lg #Nerd Fonts: Slashed zeros, customized version of Apple's Menl
      nerd-fonts.proggy-clean-tt
      nerd-fonts.tinos
      nerd-fonts.shure-tech-mono # Nerd Fonts: Dotted zeros, distinguishable 1 and l, curved and straight character lines
           nerd-fonts.symbols-only  # Fallback symbols for patched fonts
            tt2020            # Terminal Typewriter 2020 font
      openmoji-color # Open-source emojis for designers, developers and everyone else
      # noto-fonts-emoji  # = Noto Color Emoji
     # unfree  joypixels         # Emoji font
      open-sans         # Sans-serif UI font
      # noto-fonts       # Optionally enable Google's Noto family (uncomment if needed)
      # dejavu_fonts      # Popular fallback serif/sans fonts
    ];
   # enableDefaultPackages = false;  # Disable default font packages from NixOS
    enableDefaultPackages = true;  # Disable default font packages from NixOS
    enableGhostscriptFonts = true;     # Include Ghostscript fonts (for PDFs/PostScript)
    fontDir.enable = true;  # Symlink fonts to /run/current-system/sw/share/fonts for compatibility
   
   fontconfig = {
      enable = true;  # Enable fontconfig system-wide
      includeUserConf = false;    # Ignoriere benutzerspezifische Konfigurationen für ein 100% deklaratives Setup
      useEmbeddedBitmaps = false;# Ergebnis ist in der Regel eine glattere, konsistentere und ästhetisch ansprechendere Darstellung auf modernen Displays. D
     # useEmbeddedBitmaps = true;  #  Legt fest, ob eingebettete Bitmap-Glyphen zurückgreifen soll, 
      # die in vielen Schriftarten enthalten sind.
      antialias = true;  # Enable font antialiasing (smoother edges)
        subpixel.rgba = "rgb";  # Subpixel hinting order (default for LCDs)
        subpixel.lcdfilter = "default"; # "none", "default", "light", "legacy"
        hinting.enable = true;
        hinting.autohint = false; # Wenn Ihre Schriften gutes natives Hinting haben
        hinting.style = "full";
        
# localConf  # System-wide customization file contents, has higher priority than defaultFonts settings.
      localConf = ''<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
  <fontconfig>
     <alias>
	<family>sans-serif</family>
	<prefer>
	  <family>Open Sans</family>
	  <family>DejaVu Sans</family>
	  <family>Symbols Nerd Font</family>
	</prefer>
      </alias>

      <alias>
	<family>serif</family>
	<prefer>
	  <family>Tinos Nerd Font</family>
	  <family>DejaVu Serif</family>https://www.bkent.net/Doc/mdarchiv.pdf
	  <family>Symbols Nerd Font</family>
	</prefer>
      </alias>

      <alias>
	<family>monospace</family>
	<prefer>
	  <family>Hack Nerd Font</family>
	  <family>3270 Nerd Font</family>
	  <family>Lekton Nerd Font</family>
	  <family>Monofur Nerd Font</family>
	  <family>ProggyClean Nerd Font</family>
	  <family>MesloLGS Nerd Font</family>
	  <family>TT2020</family>
	  <family>Agave Nerd Font</family>
	  <family>Symbols Nerd Font</family>
	</prefer>
      </alias>
      
      <alias>
	<family>emoji</family>
	<prefer>
	  <family>openmoji-color</family>
	</prefer>
      </alias>
    </fontconfig>
'';
 
# Set default fonts by type
   /*   defaultFonts = {
        sansSerif = 	[ "Open Sans" "DejaVu Sans" 	 "Symbols Nerd Font" ];
        serif =   		[ "Tinos Nerd Font" "DejaVu Serif" "Symbols Nerd Font" ];
        emoji =	        [ "openmoji-color " ];
        monospace =  [    # "Iosevka Term Slab Nerd Font" 
         			  "Hack Nerd Font"
      				  "3270 Nerd Font"               "Lekton Nerd Font"
          			  "Monofur Nerd Font"          "ProggyClean Nerd Font"
         			  "MesloLGS Nerd Font"        "TT2020"
        			  "Agave Nerd Font"              			"Symbols Nerd Font"        ];
        
      }; */
    };
  };
}



