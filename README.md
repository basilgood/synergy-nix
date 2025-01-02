# synergy-nix
A nix flake to run Symless's Synergy

To get started first add the input:

```
inputs.synergy-nix = {
    url = "github:megheaiulian/synergy-nix";
    inputs.nixpkgs.follows = "nixpkgs";
};
```

and the use the module:

```
    synergy-nix.nixosModules.synergy

```
