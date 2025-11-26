{
  description = "Home Manager configuration for user 'auberge'";

  # --- Inputs ------------------------------------------------------------------
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # --- Outputs -----------------------------------------------------------------
  outputs = { self, nixpkgs, home-manager, nixgl, ... }:
    let
      # Adjust for your architecture if needed.
      system = "x86_64-linux";

      # Centralize nixpkgs import here for clarity.
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      # Home Manager configuration for this user.
      homeConfigurations.auberge = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
        extraSpecialArgs = { inherit nixgl; };
      };
    };
}
