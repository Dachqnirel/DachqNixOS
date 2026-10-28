# Firefox с политиками и принудительно установленными расширениями
let
  # Маленький помощник, чтобы не повторять одно и то же 4 раза
  addon = slug: {
    installation_mode = "force_installed";
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
  };
in
{
  programs.firefox = {
    enable = true;
    policies = {
      DisablePrivateBrowsing  = true;
      DisableProfileImport    = true;
      DisableFirefoxAccounts  = true;

      ExtensionSettings = {
        "uBlock0@raymondhill.net"                = addon "ublock-origin";
        "{4b92896c-e84d-4578-92bb-67f57e2dc7e2}" = addon "safe-web";
        "{88ebde3a-4581-4c6b-8019-2a05a9e3e938}" = addon "hide-youtube-shorts";
        "undistracted.developer@gmail.com"       = addon "undistracted";
      };
    };
  };

  # Firefox работает через XWayland — обход проблем отрисовки на NVIDIA
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "0";
}
