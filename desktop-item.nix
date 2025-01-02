{ makeDesktopItem }: makeDesktopItem {
  desktopName = "Synergy";
  exec = "synergy";
  name = "synergy";
  icon = "synergy";
  startupWMClass = "Synergy";
  type = "Application";
  terminal = false;
  comment = ''Use the keyboard, mouse, or trackpad of one computer to control nearby computers.'';
  categories = [ "Utility" ];
}
