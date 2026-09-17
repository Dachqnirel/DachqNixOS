{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";
  };

  outputs = { self, nixpkgs, zapret-discord-youtube, ... }: {
    nixosConfigurations = {
      # "nixos" - это networking.hostName из твоего конфига
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          zapret-discord-youtube.nixosModules.default
        ];
      };
    };
  };
}
