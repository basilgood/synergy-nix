{ stdenvNoCC
, stdenv
, lib
, dpkg
, autoPatchelfHook
, makeWrapper
, fetchurl
, openssl
, udev
, libglvnd
, libX11
, alsa-lib
, libpulseaudio
, libva
, glibc
, xorg
, libxkbcommon
, cairo
, pango
, expat
, nss
, libnotify
, cups
, atk
, gtk3
, libei
, qt6
, libGL
, libgbm
, libdrm
, vulkan-loader
, pciutils
, mesa
, libappindicator-gtk3
, wrapGAppsHook3
, gobject-introspection

  # , libXcursor
  # , libXi
  # , libXrandr
  # , libXfixes
  # , ffmpeg_6
  # , libpng
  # , libjpeg8
  # , curl
  # , vulkan-loader
  # , zenity
}:

stdenvNoCC.mkDerivation {
  pname = "synergy";
  version = "3.2.1";

  src = fetchurl {
    url = "https://symless.com/synergy/synergy/api/download/synergy-3.2.1-linux-noble-x64.deb";
    sha256 = "sha256-2rZFF20+APhg64u4IqgVWay8joIgMZzazaN4KL/HnYc=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
    gobject-introspection
    qt6.wrapQtAppsHook
    libappindicator-gtk3
  ];

  deps = [

  ];

  buildInputs = [
    stdenv.cc.cc # libstdc++
    libglvnd
    libX11
    openssl
    glibc
    alsa-lib
    libpulseaudio
    udev
    libva
    libxkbcommon
    cairo
    pango
    expat
    nss
    libnotify
    cups
    atk
    gtk3
    libei
    libGL
    libgbm
    qt6.qtbase
  ] ++ (with xorg; [
    libXrandr
    libXcursor
    libXcomposite
    libXtst
    libXinerama
    libXdamage
    libxkbfile
    libXi
    libXtst
    libXrandr
  ]);

  runtimeDependenciesPath = lib.makeLibraryPath [
    stdenv.cc.cc
    libGL
    libdrm
    libgbm
    vulkan-loader
    mesa
    xorg.libXtst
    # libglvnd
    # openssl
    # libdrm

    #     ffmpeg_6
    #     libpng
    #     libjpeg8
    #     curl
    #     libX11
    #     libXcursor
    #     libXi
    #     libXrandr
    #     libXfixes
    #     vulkan-loader
  ];

  # binPath = lib.makeBinPath [
  #   zenity
  # ];
  # qtWrapperArgs = [
  #   "--set QT_QPA_PLATFORM_PLUGIN_PATH ${qt6.qtwayland}/${qt6.qtbase.qtPluginPrefix}/platforms"
  # ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv usr/* opt/* $out
    ln -sr "$out/Synergy/synergy" "$out/bin/"

    # patch libANGLE
    patchelf \
      --set-rpath "${lib.makeLibraryPath [ libGL pciutils ]}" \
      --set-rpath "${lib.makeLibraryPath [ libGL pciutils vulkan-loader ]}" \
      $out/Synergy/lib*GL*

    # replace bundled vulkan-loader
    rm "$out/Synergy/libvulkan.so.1"
    ln -s -t "$out/Synergy" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"

    wrapProgram $out/bin/synergy \
      --prefix LD_LIBRARY_PATH : "$runtimeDependenciesPath"

    substituteInPlace $out/share/applications/synergy.desktop \
      --replace "/opt/Synergy/synergy" "synergy"

    runHook postInstall
  '';

  # Only the main binary needs to be patched, the wrapper script handles
  # everything else. The libraries in `share/parsec/skel` would otherwise
  # contain dangling references when copied out of the nix store.
  dontAutoPatchelf = true;

  fixupPhase = ''
    runHook preFixup

    autoPatchelf $out/Synergy

    runHook postFixup
  '';

  meta = with lib; {
    homepage = "https://symless.com/synergy";
    changelog = "https://symless.com/synergy/download/release-notes/11";
    description = "Share one mouse ";
    platforms = platforms.linux;
    # mainProgram = "parsecd";
  };
}
