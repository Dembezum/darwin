{ inputs, pkgs, ... }:
# configuration.nix

{
  environment.systemPackages = with pkgs; [
    gotop
    vim
    curl
    wget
    htop
    btop
    inputs.nixvim-flake.packages.${system}.default

  ];

  users.users.kristian.home = "/Users/kristian";
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true; # default shell on catalina
  system.stateVersion = 3;

  nix.configureBuildUsers = true;

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
