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
      retroarchFull
      vscode
      zellij
    ] ++ lib.optionals hasCurrentTime [
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
      # EDITOR = "emacs";
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
      };
    };
  };
}
