# ArtCraft-приложения. Запуск: меню Plasma или командой по имени
{ inputs, ... }:

{
  imports = [ inputs.nix-craftapps.nixosModules.default ];

  programs.craftapps = {
    enable = true;
    apps.photocraft.enable = true;   # ≈ Photoshop
    apps.wordcraft.enable  = true;   # ≈ Word
    apps.deckcraft.enable  = true;   # ≈ PowerPoint
    apps.gridcraft.enable  = true;   # ≈ Excel
    apps.cadcraft.enable   = true;   # ≈ AutoCAD
  };
}
