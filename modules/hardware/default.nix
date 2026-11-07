# Железо, общее для любой машины. Что именно стоит в ноутбуке —
# задаётся опциями machine.* в hosts/<имя>/default.nix.
{
  imports = [
    ./graphics.nix
    ./nvidia.nix # включается только при machine.nvidia.enable = true
    ./audio.nix
    ./bluetooth.nix
  ];
}
