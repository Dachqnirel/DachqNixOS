# ArtCraft-приложения. Запуск: меню Plasma или `photocraft` / `deckcraft`
{ inputs, ... }:

{
  imports = [ inputs.nix-craftapps.nixosModules.default ];

  programs.craftapps = {
    enable = true;
    apps.photocraft.enable = true;
    apps.deckcraft.enable  = true;
  };
}
