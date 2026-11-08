# Только для игрового пользователя (см. modules/gaming)
{ pkgs, ... }:

let
  p = import ../theme/palette.nix; # цвета без «#» — как их ждёт MangoHud
in
{
  # ── Оверлей и ограничитель кадров ───────────────────────────────────
  # MangoHud включён для всех игр Steam, но спрятан.
  #   Shift_R+F12 — показать/скрыть: FPS, видеокарта, температуры
  #   Shift_L+F1  — лимит кадров: 120 → 60 → без лимита
  # Лимит 120 по умолчанию: экран 165 Гц, а лишние кадры — это лишние
  # градусы и шум вентиляторов при почти той же плавности.
  programs.mangohud = {
    enable = true;
    settings = {
      no_display = true;
      fps_limit = [
        120
        60
        0
      ];
      toggle_fps_limit = "Shift_L+F1";
      toggle_hud = "Shift_R+F12";

      gpu_name = true; # видно, на какой видеокарте идёт игра
      gpu_temp = true;
      gpu_power = true;
      cpu_temp = true;
      ram = true;
      vram = true;
      frametime = true;
      fps_limit_hud = true; # показывать текущий лимит

      position = "top-left";
      font_size = 18;
      round_corners = 6;
      background_alpha = 0.75;
      background_color = p.base00;
      text_color = p.base05;
      gpu_color = p.base08; # красный акцент
      cpu_color = p.base0F; # бронза
      ram_color = p.base04;
      vram_color = p.base04;
      frametime_color = p.base0B;
    };
  };

  # ── Режим питания ───────────────────────────────────────────────────
  # Пока игровой пользователь в системе — профиль «Производительность»:
  # у Lenovo он же поднимает обороты вентиляторов, и железо охлаждается
  # раньше, чем начнёт сбрасывать частоты. При выходе профиль
  # возвращается к прежнему сам.
  systemd.user.services.performance-hold = {
    Unit.Description = "Профиль «Производительность» на время игрового сеанса";
    Service.ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl launch -p performance -r Игры -- ${pkgs.coreutils}/bin/sleep infinity";
    Install.WantedBy = [ "default.target" ];
  };
}
