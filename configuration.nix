# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/graphics.nix    # Imported NVIDIA and fonts settings
      ./modules/firefox.nix     # Imported Firefox settings\
      ./happ-nixos/happ-module.nix

    ];

  # Enable Flakes support natively
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:caps_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable ZSH
  programs.zsh = {
    enable = true;
    shellInit = "echo 'Welcome to NixOS!'";
  };

  # Enable Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  #v2ray
  services.v2raya.enable= true;

  # Define your user account
  users.users."dachqnirel" = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "dachQnirel";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Throne settings
  programs.throne = {
    enable = true;
    tunMode = {
      enable = true;
      setuid = true;
    };
  };

  services.happ.enable = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    wget
    obsidian
    yt-dlp
    ffmpeg
    zotero
    git
    docker-compose
    vscode
    telegram-desktop
    lshw
    python3
    alacritty
    sl
    home-manager
    rustup
    oniux
    ollama
    libreoffice-stable
    ayugram-desktop
    kitty
    brightnessctl
  ];

  system.stateVersion = "26.05";
}
