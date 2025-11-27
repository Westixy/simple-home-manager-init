{ config, pkgs, nixgl, ... }:

let
  lib = pkgs.lib;
  hasCurrentTime = builtins ? currentTime;
in
{
  /*
    Home Manager configuration for user 'auberge'.
    - Clean grouping and concise comments
    - Alphabetized package list
    - Consistent spacing and section headers
  */

  # --- Identity & state --------------------------------------------------------
  home = {
    username = "auberge";
    homeDirectory = "/home/auberge";

    # Do not change lightly; see Home Manager release notes before updating.
    stateVersion = "25.05";

    # Avoid warns when HM version lags behind nixpkgs releases.
    enableNixpkgsReleaseCheck = false;

    # Packages installed for this user.
    packages = with pkgs; [
      direnv
      nh
      codium
      multiplex
      deluge
      zellij
      firefox
      (pkgs.runCommand "firefox-mobile" { preferLocalBuild = true; } ''
        mkdir -p $out/bin
        ln -s ${pkgs.firefox-mobile}/bin/firefox $out/bin/firefox-mobile
      '')
      (pkgs.runCommand "firefox-dev" { preferLocalBuild = true; } ''
        mkdir -p $out/bin
        ln -s ${pkgs.firefox-devedition}/bin/firefox $out/bin/firefox-dev
      '')
    ] ++ lib.optionals hasCurrentTime [
      retroarchFull
      (nixgl.packages.${pkgs.system}.nixGLDefault)
    ];

    # Managed files (dotfiles, config snippets, etc.)
    file = {
      # Example:
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # Environment variables for shells managed by Home Manager.
    sessionVariables = {
      EDITOR = "code";
    };
  };

  # --- Nixpkgs configuration ---------------------------------------------------
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # --- Programs ----------------------------------------------------------------
  programs = {
    home-manager.enable = true;
    fish = {
      enable = true;
      shellAliases = lib.optionalAttrs hasCurrentTime {
        retroarch = "nixGL retroarch";
      } // {
        nh-switch = "nh home switch $HOME/.config/home-manager -- --impure";
        nh-update = "cd $HOME/.config/home-manager && git stash && git pull --rebase && git stash pop && nh home switch $HOME/.config/home-manager -- --impure; cd -";
        nh-edit = "code $HOME/.config/home-manager";
      };
    };
  };
}
