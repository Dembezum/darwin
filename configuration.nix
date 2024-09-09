{ inputs, pkgs, ... }:
# configuration.nix

{
  imports = [
    ./universal.nix

  ];

  environment.systemPackages = with pkgs; [
    gotop
    curl
    inputs.nixvim-flake.packages.${system}.default

  ];

  users.users.kristian.home = "/Users/kristian";
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  security.pam.enableSudoTouchIdAuth = true;

  programs.zsh.enable = true;
  system.stateVersion = 3;

  nix.configureBuildUsers = true;

  system = {
    defaults = {
      CustomUserPreferences = {
        # Avoid creating .DS_Store files on network or USB volumes
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
      };
      # Where to save screenshots
      screencapture.location = "~/Downloads";
      # Show hidden files in Finder
      finder = { AppleShowAllFiles = true; };
    };
  };
  homebrew = {
    enable = true;
    #  global.autoIpdate = false;

    casks = [
      "kitty"
      "firefox"
      "drawio"

    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
