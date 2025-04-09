{ inputs, pkgs, ... }:
# configuration.nix

{
  imports = [
    ./universal.nix

  ];

  ids.gids.nixbld = 350;

  environment = {
    variables = {
      CURL_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt";

    };
    systemPackages = with pkgs; [
      wireguard-tools
      gotop
      curl
      cacert
      inputs.nixvim-flake.packages.${system}.default

    ];
  };

  users.groups.wheel.members = [ "kristian" ];

  users.users.kristian.home = "/Users/kristian";
  nix.settings.experimental-features = "nix-command flakes";


  programs.zsh.enable = true;
  system.stateVersion = 3;


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

    taps = [

    ];
    casks = [
      "kitty"
      "firefox"
      "discord"
      "drawio"
      "freecad"
      "bambu-studio"
      "bambu-studio"
      "keyboard-maestro"
      "podman-desktop"

    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
