# synergy-nix
A nix flake to run Symless's Synergy

To get started first add the input:

```nix
inputs.synergy-nix = {
    url = "github:megheaiulian/synergy-nix";
    inputs.nixpkgs.follows = "nixpkgs";
};
```

and than use the module:

```nix
    synergy-nix.nixosModules.synergy

```

for update synergy:
- first "Download as guest" synergy-3.3.1-linux-noble-x64.deb manually from here: 
[synergy](https://symless.com/synergy/download/package/synergy-personal-v3/ubuntu-24.04/synergy-3.3.1-linux-noble-x64.deb)
- suppose it's in the Downloads folder after download, run this command:
`nix-store --add-fixed sha256 ~/Downloads/synergy-3.3.1-linux-noble-x64.deb`
- it will output something like this:
`/nix/store/h0rwcn06k9zbnbap3f4928fr81r9nncl-synergy-3.3.1-linux-noble-x64.deb`
- run this command:
`nix-prefetch-url --type sha256 file://$HOME/Downloads/synergy-3.3.1-linux-noble-x64.deb`
- attention it needs absolute path to were is synergy-3.3.1-linux-noble-x64.deb
- it will output something like this:
```bash
path is '/nix/store/h0rwcn06k9zbnbap3f4928fr81r9nncl-synergy-3.3.1-linux-noble-x64.deb'
13yny6vlrxkfqarskfcwp18abjsizq8r9iqibp9ipyvqd2z1h1l2
```
- the second line is the hash that needs to be replaced in package.nix:
  `sha256 = "replace with this hash"`
- now you can build the package
  `nix build .#synergy`
