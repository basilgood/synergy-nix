{ buildFHSEnv
, writeShellScript
, python3
, ripgrep
, bc
, jq
, openssh
, glib
, fontconfig
, freetype
, pango
, cairo
, atk
, nss
, nspr
, alsa-lib
, expat
, cups
, dbus
, dbus-glib
, gdk-pixbuf
, gcc-unwrapped
, systemd
, libexif
, pciutils
, liberation_ttf
, curl
, util-linux
, wget
, flac
, harfbuzz
, icu
, libpng
, snappy
, speechd
, bzip2
, libcap
, at-spi2-atk
, at-spi2-core
, libkrb5
, libdrm
, libglvnd
, mesa
, coreutils
, libxkbcommon
, libxkbfile
, pipewire
, wayland
, gtk3
, gtk4
, udev
, libX11
, libXcursor
, libXrandr
, libXext
, libXfixes
, libXrender
, libXScrnSaver
, libXcomposite
, libxcb
, libXi
, libXdamage
, libXtst
, libxshmfence
, lz4
, libz
, libei
, openssl
, libappindicator-gtk3
, libXinerama
, callPackage
, qt6
, libnotify
}:
let
  synergy =
    (callPackage ./package.nix { });
in
(buildFHSEnv
{
  name = "synergy-env";
  targetPkgs = pkgs: [ synergy ] ++ [
    udev
    alsa-lib
    python3
    ripgrep
    bc
    jq
    openssh
  ] ++ [
    libX11
    libXcursor
    libXext
    libXfixes
    libXrender
    libXScrnSaver
    libXcomposite
    libxcb
    libXi
    libXdamage
    libXtst
    libXrandr
    libxshmfence
  ] ++ [
    glib
    fontconfig
    freetype
    pango
    cairo
    atk
    nss
    nspr
    alsa-lib
    expat
    cups
    dbus
    dbus-glib
    gdk-pixbuf
    gcc-unwrapped.lib
    systemd
    libexif
    pciutils
    liberation_ttf
    curl
    util-linux
    wget
    flac
    harfbuzz
    icu
    libpng
    snappy
    speechd
    bzip2
    libcap
    at-spi2-atk
    at-spi2-core
    libkrb5
    libdrm
    libglvnd
    mesa
    coreutils
    libxkbcommon
    libxkbfile
    pipewire
    wayland
    gtk3
    gtk4
    lz4
    libz
    openssl
    libappindicator-gtk3
    libei
    libXinerama
    qt6.qtbase
    libnotify
  ];
  extraBwrapArgs = [
    "--symlink $HOME/.synergy /etc/Synergy"
  ];
  extraInstallCommands =
    let
      desktopItem = (callPackage ./desktop-item.nix { });
      synergyBin = writeShellScript "synergy" ''
        exec $(dirname "$0")/synergy-env -c "exec /opt/Synergy/synergy $@"
      '';
    in
    ''
      mkdir -p $out/share/{applications,}
      ln -sfv ${synergy}/share/icons $out/share/icons
      ln -sfv ${desktopItem}/share/applications/synergy.desktop $out/share/applications
      ln -sfv ${writeShellScript "synergy" ''
        exec $(dirname "$0")/synergy-env -c "exec /opt/Synergy/synergy $@"
      ''} $out/bin/synergy
      ln -sfv ${writeShellScript "synergy-service" ''
        exec $(dirname "$0")/synergy-env -c "exec /opt/Synergy/synergy-service $@"
      ''} $out/bin/synergy-service

    '';
})
