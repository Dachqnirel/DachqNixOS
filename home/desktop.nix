# GTK-программы, курсор и обои в палитре системы
{ pkgs, ... }:

let
  p = import ../theme/palette.nix;
  c = p.hex;

  # Цвета для GTK 3 и GTK 4 (libadwaita): графит + красный акцент
  colors = ''
    @define-color accent_color ${c.base08};
    @define-color accent_bg_color ${c.base08};
    @define-color accent_fg_color ${c.base07};
    @define-color destructive_bg_color ${c.base08};
    @define-color window_bg_color ${c.base00};
    @define-color window_fg_color ${c.base05};
    @define-color view_bg_color ${c.base00};
    @define-color view_fg_color ${c.base05};
    @define-color headerbar_bg_color ${c.mid};
    @define-color headerbar_fg_color ${c.base05};
    @define-color sidebar_bg_color ${c.mid};
    @define-color sidebar_fg_color ${c.base05};
    @define-color card_bg_color ${c.base01};
    @define-color card_fg_color ${c.base05};
    @define-color dialog_bg_color ${c.mid};
    @define-color dialog_fg_color ${c.base05};
    @define-color popover_bg_color ${c.base01};
    @define-color popover_fg_color ${c.base05};
  '';

  # Новые версии libadwaita читают цвета из CSS-переменных
  gtk4Vars = ''
    :root {
      --accent-bg-color: ${c.base08};
      --accent-fg-color: ${c.base07};
      --accent-color: ${c.base08};
      --window-bg-color: ${c.base00};
      --window-fg-color: ${c.base05};
      --view-bg-color: ${c.base00};
      --view-fg-color: ${c.base05};
      --headerbar-bg-color: ${c.mid};
      --sidebar-bg-color: ${c.mid};
      --card-bg-color: ${c.base01};
      --dialog-bg-color: ${c.mid};
      --popover-bg-color: ${c.base01};
    }
  '';
in
{
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "grey"; };
    };
    font = {
      name = p.font.sans;
      size = p.font.size;
      package = pkgs.ibm-plex;
    };
    gtk3.extraCss = colors;
    gtk4.extraCss = colors + gtk4Vars;
  };

  # Один курсор везде: в niri, GTK и X11-программах
  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Обои: ~/Pictures/Wallpapers/machine/ (свои можно класть рядом)
  home.file."Pictures/Wallpapers/machine" = {
    source = ./wallpapers;
    recursive = true;
  };
}
