{ buildFHSEnv
, nodejs_20
, nodePackages
, python3
, ripgrep
, bc
, prefetch-npm-deps
, jq
, git
, git-lfs
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
, openssl
, libappindicator-gtk3
, callPackage
}:
(buildFHSEnv
{
  name = "synergy";
  targetPkgs = pkgs: [ (callPackage ./package.nix { }) ] ++ [
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
  ];
  #runScript = "/opt/Synergy/synergy";
})
