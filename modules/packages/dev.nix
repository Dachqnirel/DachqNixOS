# Разработка
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vscode
    rustup
    ollama
    home-manager
  ];
}
