{ stdenvNoCC
, stdenv
, lib
, dpkg
, autoPatchelfHook
, makeWrapper
, fetchurl
, alsa-lib
, openssl
, udev
, libglvnd
, libX11
, libXcursor
, libXi
, libXrandr
, libXfixes
, libpulseaudio
, libva
, ffmpeg_6
, libpng
, libjpeg8
, curl
, vulkan-loader
, zenity
,
}:

stdenvNoCC.mkDerivation {
  pname = "synergy";
  version = "3.2.1";

  src = fetchurl {
    url = "https://symless.com/synergy/download/package/ubuntu/synergy-3.2.1-linux-noble-x64.deb";
    sha256 = "sha256-9F56u+jYj2CClhbnGlLi11FxS1Vq00coxwu7mjVTY1w=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc # libstdc++
    libglvnd
    libX11
  ];

  runtimeDependenciesPath = lib.makeLibraryPath [
    stdenv.cc.cc
    libglvnd
    openssl
    udev
    alsa-lib
    libpulseaudio
    libva
    ffmpeg_6
    libpng
    libjpeg8
    curl
    libX11
    libXcursor
    libXi
    libXrandr
    libXfixes
    vulkan-loader
  ];

  binPath = lib.makeBinPath [
    zenity
  ];

  installPhase = ''
    runHook preInstall
    ls -al .
    mkdir $out
    mv usr/* $out

    wrapProgram $out/bin/parsecd \
      --prefix PATH : "$binPath" \
      --prefix LD_LIBRARY_PATH : "$runtimeDependenciesPath"
      # --run "$prepareParsec"

    substituteInPlace $out/share/applications/parsecd.desktop \
      --replace "/usr/bin/parsecd" "parsecd" \
      --replace "/usr/share/icons" "${placeholder "out"}/share/icons"

    runHook postInstall
  '';

  # Only the main binary needs to be patched, the wrapper script handles
  # everything else. The libraries in `share/parsec/skel` would otherwise
  # contain dangling references when copied out of the nix store.
  dontAutoPatchelf = true;

  fixupPhase = ''
    runHook preFixup

    autoPatchelf $out/bin

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
