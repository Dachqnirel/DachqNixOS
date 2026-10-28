# Настройки самого Nix: flakes, unfree, автоочистка
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;   # дедупликация одинаковых файлов в /nix/store
  };

  nixpkgs.config.allowUnfree = true;   # NVIDIA, VS Code, Obsidian и т.п.

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
