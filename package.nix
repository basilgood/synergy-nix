{ stdenvNoCC, dpkg, requireFile, ... }:

stdenvNoCC.mkDerivation rec {
  pname = "synergy";
  version = "3.3.1";
  src = requireFile {
    name = "${pname}-${version}-linux-noble-x64.deb";
    url = "https://symless.com/synergy/download/package/synergy-personal-v3/ubuntu-24.04/";
    sha256 = "13yny6vlrxkfqarskfcwp18abjsizq8r9iqibp9ipyvqd2z1h1l2";
  };
  nativeBuildInputs = [ dpkg ];
  installPhase = ''
    mkdir -p $out/bin
    mv * $out/
    ln -sr "$out/usr/share" "$out/share"
    ln -sr "$out/opt/Synergy/synergy" "$out/bin/"
  '';
}
