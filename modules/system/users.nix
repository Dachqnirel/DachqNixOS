# Пользователь. `username` приходит из flake.nix (specialArgs),
# поэтому имя записано ровно в одном месте.
{ pkgs, username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    description  = "dachQnirel";
    shell        = pkgs.zsh;
    extraGroups  = [
      "wheel"            # sudo
      "networkmanager"
      "video"
      "audio"
      "docker"
      "libvirtd"         # управление виртуалками без sudo
      "kvm"
    ];
  };
}
