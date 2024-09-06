{ pkgs, ...}:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
  };

environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    win-spice
    win-virtio
    spice
    spice-gtk
    spice-protocol
    qemu_kvm
    libvirt
    #ovmf
  ];
}
