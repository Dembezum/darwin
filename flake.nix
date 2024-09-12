{
  description = "Darwin flake";

  inputs = {
    # Importing the unstable version of nixpkgs from GitHub
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Importing my nixvim flake from GitHub
    nixvim-flake.url = "github:dembezum/nixvim";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Importing nix-homebrew from GitHub
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
        system = "aarch64-darwin"; # System architecture
        hostname = "kristian-mbp"; # Hostname of the machine
        profile = "kristian"; # Profile name
        systemstate = "24.05"; # System state version
      };

      # --- USER CONFIGURATION ---
      userSettings = {
        username = "kristian"; # Username
        name = "Kristian"; # Full name
        editor = "nvim"; # Preferred editor
        term = "xterm-256color"; # Terminal type
        terminal = "foot"; # Terminal emulator
        browser = "firefox"; # Preferred browser
        video = "feh"; # Video player
        image = "mpv"; # Image viewer
        homestate = "24.05"; # Home state version
      };

      # Importing nixpkgs with specific system settings
      pkgs = import nixpkgs {
        inherit (systemSettings) system;
        config.allowUnfree = true; # Allow unfree packages
      };

    in {
      darwinConfigurations = {
        kristian = nix-darwin.lib.darwinSystem {
          inherit pkgs;
          inherit (systemSettings) system;
          modules = [
            ./configuration.nix # Main configuration file
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true; # Use global packages
                useUserPackages = true; # Use user-specific packages
                users.kristian = import ./home.nix {
                  inherit inputs pkgs systemSettings userSettings;
                };
              };
            }
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true; # Enable nix-homebrew
                user = userSettings.username; # User for nix-homebrew
                autoMigrate = true; # Automatically migrate
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
