# KDE Plasma 6 + SDDM
{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = [ pkgs.kdePackages.kate ];
}
