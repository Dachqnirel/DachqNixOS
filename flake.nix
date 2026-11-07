{
  description = "NixOS-конфигурация dachQnirel";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Разметка диска кодом — для установки на новые ноутбуки
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microlauncher = {
      url = "github:Dachqnirel/microlauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-craftapps = {
      url = "github:olafkfreund/nix-craftapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      username = "dachqnirel";

      # Одна система = одна папка в hosts/ (кроме шаблона)
      hosts = lib.attrNames (
        lib.filterAttrs (name: type: type == "directory" && name != "template") (builtins.readDir ./hosts)
      );

      mkHost =
        host:
        lib.nixosSystem {
          specialArgs = { inherit inputs username; };
          modules = [
            ./hosts/${host}
            home-manager.nixosModules.home-manager
          ];
        };
    in
    {
      # Сборка: sudo nixos-rebuild switch --flake /etc/nixos
      # (система выбирается по имени компьютера, т.е. hostName)
      nixosConfigurations = lib.genAttrs hosts mkHost;
    };
}
