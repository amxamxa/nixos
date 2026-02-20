# rust.nix
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkMerge;
in

mkMerge [

  # --- cargo aliases ---
  (mkIf (builtins.hasAttr "cargo" pkgs) {
    environment.shellAliases = {

      # --- build ---
      cb   = "cargo build";
      cbr  = "cargo build --release";
      cbrv = "cargo build --release --verbose";

      # --- run ---
      cr   = "cargo run";
      crr  = "cargo run --release";
      crv  = "cargo run --verbose";

      # --- test ---
      ct   = "cargo test";
      ctr  = "cargo test --release";
      ctv  = "cargo test --verbose";
      ctw  = "cargo test -- --nocapture";

      # --- check / clippy / fmt ---
      cc   = "cargo check";
      ccl  = "cargo clippy";
      cclf = "cargo clippy --fix";
      cfmt = "cargo fmt";
      cfmc = "cargo fmt --check";

      # --- doc ---
      cdoc  = "cargo doc";
      cdoco = "cargo doc --open";

      # --- dependencies ---
      ca    = "cargo add";
      crm   = "cargo remove";
      cup   = "cargo update";
      cout  = "cargo outdated";

      # --- misc ---
      cln   = "cargo clean";
      cbn   = "cargo bench";
      cinf  = "cargo info";
      ctree = "cargo tree";
      cfix  = "cargo fix";

      # --- watch ---
      cw  = "cargo watch -x run";
      cwt = "cargo watch -x test";
      cwc = "cargo watch -x check";
    };
  })

  # --- packages ---
  {
    environment.systemPackages = with pkgs; [
      rustup
      cargo-watch
      cargo-outdated
      cargo-edit
      cargo-expand
      cargo-audit
    ];
  }

]



