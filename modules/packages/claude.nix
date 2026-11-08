# ─────────────────────────────────────────────────────────────────────
#  Claude Code и прокси «по выбору»: через прокси ходит только то,
#  что запущено через него, остальная система — напрямую.
#
#  Адрес прокси НЕ хранится в этом репозитории (он публичный):
#    proxy-set http://логин:пароль@хост:порт      — HTTP-прокси
#    proxy-set socks5://логин:пароль@хост:порт    — SOCKS5
#  Он ложится в ~/.config/proxy/url с правами 600.
#
#  claude        — Claude Code, всегда через прокси
#  px <команда>  — любая программа через прокси: px git push, px curl …
#  proxy-set -   — убрать прокси
#
#  Claude Code понимает только HTTP-прокси, поэтому для SOCKS5 в фоне
#  поднимается локальный мост (gost): 127.0.0.1:18080 → твой SOCKS5.
# ─────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

let
  bridge = "http://127.0.0.1:18080";
  urlFile = ''"''${XDG_CONFIG_HOME:-$HOME/.config}/proxy/url"'';

  # Выставляет переменные прокси, если адрес задан
  proxyEnv = ''
    f=${urlFile}
    if [ -r "$f" ] && url=$(head -n1 "$f") && [ -n "$url" ]; then
      case "$url" in
        socks*://*) url="${bridge}" ;; # SOCKS5 — через локальный мост
      esac
      export HTTPS_PROXY="$url" HTTP_PROXY="$url" https_proxy="$url" http_proxy="$url"
      export NO_PROXY="localhost,127.0.0.1,::1" no_proxy="localhost,127.0.0.1,::1"
    fi
  '';

  px = pkgs.writeShellScriptBin "px" ''
    ${proxyEnv}
    exec "$@"
  '';

  claude = pkgs.writeShellScriptBin "claude" ''
    ${proxyEnv}
    exec ${pkgs.claude-code}/bin/claude "$@"
  '';

  proxySet = pkgs.writeShellScriptBin "proxy-set" ''
    set -eu
    f=${urlFile}
    if [ "''${1:-}" = "-" ]; then
      rm -f "$f"
      echo "Прокси убран."
    elif [ -n "''${1:-}" ]; then
      case "$1" in
        http://*|https://*|socks5://*|socks5h://*) ;;
        *) echo "Адрес должен начинаться с http://, https:// или socks5://" >&2; exit 1 ;;
      esac
      mkdir -p "$(dirname "$f")"
      (umask 077; printf '%s\n' "$1" > "$f")
      echo "Прокси сохранён в $f"
    else
      echo "Использование: proxy-set <адрес>   или   proxy-set -   (убрать)" >&2
      exit 1
    fi
    # Мост для SOCKS5 подхватывает новый адрес
    systemctl --user restart proxy-bridge.service 2>/dev/null || true
  '';
in
{
  environment.systemPackages = [
    claude
    px
    proxySet
  ];

  # Мост HTTP → SOCKS5 для каждого пользователя; без SOCKS5-адреса молчит
  systemd.user.services.proxy-bridge = {
    description = "Мост HTTP → SOCKS5 для программ, которые не умеют SOCKS";
    wantedBy = [ "default.target" ];
    serviceConfig.Restart = "on-failure";
    script = ''
      f=${urlFile}
      url=$(head -n1 "$f" 2>/dev/null || true)
      case "$url" in
        socks*://*) exec ${pkgs.gost}/bin/gost -L ${bridge} -F "''${url/socks5h:/socks5:}" ;;
        *) exit 0 ;;
      esac
    '';
  };
}
