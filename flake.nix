{
  description = "Darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixvim-flake.url = "github:dembezum/nixvim";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = { url = "github:zhaofengli-wip/nix-homebrew"; };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew
    , homebrew-core, homebrew-cask, homebrew-bundle, ... }@inputs:
    let
      # --- SYSTEM CONFIGURATION ---
      systemSettings = {
        system = "aarch64-darwin";
        hostname = "kristian-mbp";
        profile = "kristian";
        systemstate = "24.05";
      };

      # --- USER CONFIGURATION ---
      userSettings = {
        username = "kristian";
        name = "Kristian";
        editor = "nvim";
        term = "xterm-256color";
        terminal = "foot";
        browser = "firefox";
        video = "feh";
        image = "mpv";
        homestate = "24.05";
      };

      pkgs = import nixpkgs {
        inherit (systemSettings) system;
        config.allowUnfree = true;
      };

    in {
      darwinConfigurations = {
        kristian = nix-darwin.lib.darwinSystem {
          inherit pkgs;
          inherit (systemSettings) system;
          modules = [
            ./configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.kristian = import ./home.nix {
                  inherit inputs pkgs systemSettings userSettings;
                };
              };
            }
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                user = userSettings.username;
                autoMigrate = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };
                mutableTaps = false;
              };
            }
          ];
          specialArgs = { inherit systemSettings userSettings inputs; };
        };
      };

      darwinPackages = self.darwinConfigurations.kristian.pkgs;
    };
}
