{
  description = "NixOS-конфигурация dachQnirel";

  # ── Откуда берём код ───────────────────────────────────────────────
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";

    # TODO: подставь реальный адрес репозитория и раскомментируй,
    # затем включи ./craftapps.nix в modules/packages/default.nix
    # nix-craftapps.url = "github:<владелец>/nix-craftapps";
  };

  # ── Что из этого собираем ──────────────────────────────────────────
  # `@inputs` — все входы одним набором, чтобы передать их в модули.
  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      # Имя совпадает с networking.hostName, поэтому
      # `nixos-rebuild switch --flake /etc/nixos` найдёт его сам.
      nixos = nixpkgs.lib.nixosSystem {
        # specialArgs — дополнительные аргументы, которые получит
        # КАЖДЫЙ модуль: { inputs, username, pkgs, config, ... }
        specialArgs = {
          inherit inputs;
          username = "dachqnirel";
        };

        modules = [ ./configuration.nix ];
      };
    };
  };
}
