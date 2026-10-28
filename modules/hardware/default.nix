# Железо, общее для любой машины с похожей начинкой.
# Конкретные адреса (bus ID и т.п.) — в configuration.nix.
{
  imports = [
    ./nvidia.nix
    ./audio.nix
    ./bluetooth.nix
  ];
}
