# Консольные утилиты
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    lshw
    brightnessctl
    unrar
    yt-dlp
    ffmpeg
    oniux
    sl
  ];
}
