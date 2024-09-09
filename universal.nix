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
    nfs-utils
    localsend

    # -- SYSTEM UTILITIES --
    lsof
    screen
    tree
    which
    glances
    powertop
    pciutils
    usbutils
    neofetch
    lm_sensors
    lsb-release
    inxi
    kmon

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
    parted
    fuse
    procs
    du-dust
    duf
    sdparm
    hdparm
    gptfdisk

    # -- TERMINAL UTILITIES --
    kitty
    tmux
    xclip

    # -- BOOT MANAGEMENT --
    efibootmgr
    efivar

    # -- MISCELLANEOUS UTILITIES --
    feh
    calc
    nh
    nvd
  ];

  # -- FONTS --
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
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
    settings = { auto-optimise-store = true; };
    gc = {
      automatic = true;
      dates = "weekly";
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
  programs.nix-ld.enable = true;
  services.envfs.enable = true;

}
