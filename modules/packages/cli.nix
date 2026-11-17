# Консольные утилиты
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gh
    lshw
    brightnessctl
    unrar
    yt-dlp
    ffmpeg
    oniux
    sl
  ];
}
