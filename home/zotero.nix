# Zotero → Obsidian: после каждого автоэкспорта Better BibTeX
# в .library.json запускается .zotero_sync.py хранилища и обновляет
# у заметок в sources/ статус, оценку, научность, category/meta/problem.
# Лог: journalctl --user -u zotero-sync -f
{ pkgs, config, ... }:

let
  vault = "${config.home.homeDirectory}/My Vaults/Somet/vault_cossinocs";
in
{
  systemd.user.services.zotero-sync = {
    Unit.Description = "Синхронизация Zotero → Obsidian (vault_cossinocs)";
    Service = {
      # .zotero_sync.py ищет .library.json и sources/ от текущей папки
      WorkingDirectory = vault;
      ExecStart = ''${pkgs.bash}/bin/bash "${vault}/.zotero_watcher.sh"'';
      Environment = "PATH=${pkgs.lib.makeBinPath [ pkgs.inotify-tools pkgs.python3 pkgs.coreutils ]}";
      Restart = "on-failure";
      RestartSec = 10;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
