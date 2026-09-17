{ config, pkgs, ... }:

{
  # Install and configure Firefox
  programs.firefox = {
    enable = true;
    policies = {
      DisablePrivateBrowsing = true;
      DisableProfileImport = true;
      DisableFirefoxAccounts = true;
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        "{4b92896c-e84d-4578-92bb-67f57e2dc7e2}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/safe-web/latest.xpi";
        };
        "{88ebde3a-4581-4c6b-8019-2a05a9e3e938}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/hide-youtube-shorts/latest.xpi";
        };
        "undistracted.developer@gmail.com" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/undistracted/latest.xpi";
        };
      };
    };
  };
}
