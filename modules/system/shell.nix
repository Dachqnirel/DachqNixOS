# Оболочка и редактор по умолчанию.
# Сам neovim и его настройки — в ../../home/neovim.nix
{
  programs.zsh.enable = true;

  # nvim — редактор по умолчанию: git commit, sudoedit, crontab -e и т.д.
  # Системные файлы удобно править так: sudoedit /etc/nixos/...
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
