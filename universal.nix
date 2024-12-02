{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    # -- NETWORKING TOOLS --
    whois
    iperf3
    wget
    dnsutils
    nmap
    socat
    tcpdump
    sshfs-fuse
    localsend

    # -- SYSTEM UTILITIES --
    lsof
    screen
    tree
    which
    glances
    neofetch
    inxi

    # -- DEVELOPMENT TOOLS --
    git
    vim
    shellcheck
    fzf

    # -- FILE MANAGEMENT --
    eza
    bat
    fd
    gnutar
    ncdu
    ripgrep

    # -- SYSTEM MANAGEMENT --
    killall
    htop
    btop
    du-dust
    duf
    gptfdisk

    # -- TERMINAL UTILITIES --
    kitty
    tmux

    # -- MISCELLANEOUS UTILITIES --
    feh
    calc
    nh
    nvd
  ];

  # -- FONTS --
  fonts.packages = with pkgs; [
    #    (nerd-fonts.override { fonts = [ "JetBrainsMono" ]; })
    nerd-fonts.jetbrains-mono 
    font-awesome
    material-design-icons
  ];

  # Show chnages in the system configuration
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff \
      /run/current-system "$systemConfig"
    '';
  };

  # -- NIX OPTIONS --
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  nixpkgs.config.allowUnfree = true;

  # -- Nix Enviornment --

}
