# Какой программой открывать файлы по двойному клику (Dolphin, браузер и т.д.)
let
  grid  = "ai.storyteller.gridcraft.desktop";
  calc  = "calc.desktop";
  word  = "ai.storyteller.wordcraft.desktop";
  deck  = "ai.storyteller.deckcraft.desktop";
  cad   = "ai.storyteller.cadcraft.desktop";
in
{
  xdg.mime.defaultApplications = {
    # Таблицы → GridCraft
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ calc grid ];   # .xlsx
    "application/vnd.ms-excel"                                          = [ calc grid ];   # .xls
    "application/vnd.oasis.opendocument.spreadsheet" = [ calc grid ]; # .ods
    "text/csv"                                                          = [ calc grid ];   # .csv

    # Документы → WordCraft
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = word;  # .docx
    "application/msword"                                                      = word;  # .doc

    # Презентации → DeckCraft
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" = deck; # .pptx
    "application/vnd.ms-powerpoint"                                             = deck; # .ppt

    # Чертежи → CadCraft
    "image/vnd.dxf" = cad;   # .dxf
    "image/vnd.dwg" = cad;   # .dwg

    # Папки → Dolphin (например, «Показать в папке» из Firefox)
    "inode/directory" = "org.kde.dolphin.desktop";
  };
}
