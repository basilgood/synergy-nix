{
  description = "A basic flake for symless synergy";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    {
      overlays.default = final: prev: with final; {
        synergy = callPackage ./env.nix { };
      };
      overlay = self.overlays.default;
    }
    //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
      rec {
        packages = {
          inherit (pkgs) synergy;
        };
      }
    );
}
