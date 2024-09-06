{ userSettings, pkgs, ... }:

{
  # -- IMPORTS --
  imports = [
    ./modules/user/tmux
    ./modules/user/zsh
    ./modules/user/kitty

  ];

  # -- USER SETTINGS --
  home = {
    inherit (userSettings) username;

  };
  programs.home-manager.enable = true;

  # Package configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # -- DEFAULT PACKAGES --
  home.packages = [ pkgs.lazygit ];

  # -- VARIABLES --
  home.sessionVariables = {
    EDITOR = userSettings.editor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };

  # -- XDG CONFIGURATION --
  home.stateVersion = userSettings.homestate;
}
