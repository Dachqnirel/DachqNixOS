# Сеть и файрвол (hostName задаётся в hosts/<имя>/default.nix)
{
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
}
