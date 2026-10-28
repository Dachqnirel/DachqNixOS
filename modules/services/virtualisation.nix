# KVM / libvirt — для Windows-виртуалки и WinApps
{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;   # эмуляция TPM 2.0 — нужна Windows 11
    };
  };

  programs.virt-manager.enable = true;

  # NAT-мост виртуалок не должен резаться файрволом
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  environment.systemPackages = [ pkgs.freerdp ];   # RDP-клиент для WinApps
}
