# Настройки самого Nix: flakes, unfree, автоочистка
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;   # дедупликация одинаковых файлов в /nix/store
  };

  nixpkgs.config.allowUnfree = true;   # NVIDIA, VS Code, Obsidian и т.п.

  # Zotero держится на Firefox ESR 140 (без поддержки с 13.10.2026).
  # Убрать, когда nixpkgs обновит Zotero на новый движок.
  nixpkgs.config.permittedInsecurePackages = [ "firefox-esr-140-bin-unwrapped-140.17.0esr" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
