# Home Manager: настройки в домашней папке (niri, foot, fastfetch, neovim,
# Noctalia, GTK) теперь тоже описаны в /etc/nixos и раскладываются
# автоматически при nixos-rebuild. Сами настройки — в ../../home/
{ username, ... }:

{
  home-manager = {
    useGlobalPkgs = true; # тот же nixpkgs и allowUnfree, что у системы
    useUserPackages = true; # программы ставятся в профиль пользователя
    extraSpecialArgs = { inherit username; };

    # Если в ~/.config уже лежит файл, который теперь ведёт Home Manager,
    # он не удаляется, а переименовывается в <имя>.pre-hm
    backupFileExtension = "pre-hm";
    overwriteBackup = true;

    # Рабочий профиль; игровой — в ../gaming
    users.${username}.imports = [
      ../../home
      ../../home/work.nix
    ];
  };
}
