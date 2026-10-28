# Базовая система: то, без чего машина не загрузится и не будет «твоей».
{
  imports = [
    ./boot.nix
    ./nix.nix
    ./locale.nix
    ./networking.nix
    ./users.nix
    ./shell.nix
    ./performance.nix
  ];
}
