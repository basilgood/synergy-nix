{ stdenvNoCC, dpkg, fetchurl, ... }:

stdenvNoCC.mkDerivation {
  pname = "synergy";
  version = "3.2.1";
  src = fetchurl {
    url = "https://symless.com/synergy/synergy/api/download/synergy-3.2.1-linux-noble-x64.deb";
    sha256 = "sha256-2rZFF20+APhg64u4IqgVWay8joIgMZzazaN4KL/HnYc=";
  };
  nativeBuildInputs = [ dpkg ];
  installPhase = ''
    mkdir -p $out/bin
    mv * $out/
    ln -sr "$out/usr/share" "$out/share"
    ln -sr "$out/Synergy/synergy" "$out/bin/"
  '';
}
