# Пакеты из внешнего flake nix-craftapps.
# Подключается через inputs → поэтому `inputs` в аргументах.
{ inputs, pkgs, ... }:

{
  environment.systemPackages =
    with inputs.nix-craftapps.packages.${pkgs.stdenv.hostPlatform.system}; [
      photocraft
      deckcraft
      # effectcraft — пока с битым хешом, не добавлять
    ];
}
