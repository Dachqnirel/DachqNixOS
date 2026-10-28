# Обход блокировок: zapret, Throne
{ inputs, ... }:

{
  # Модуль zapret берётся из внешнего flake (см. inputs во flake.nix)
  imports = [ inputs.zapret-discord-youtube.nixosModules.default ];

  programs.throne = {
    enable = true;
    tunMode = {
      enable = true;
      setuid = true;
    };
  };
}
