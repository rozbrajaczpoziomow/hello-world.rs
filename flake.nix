{
  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk.url = "github:nmattia/naersk";
  };
  outputs = { self, flake-utils, fenix, nixpkgs, naersk, flake-compat, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Add rust nightly to pkgs
        pkgs = nixpkgs.legacyPackages.${system} // { /* all packages that we want from the fenix scope */ inherit (fenix.packages.${system}.latest) cargo rustc rust-src clippy-preview rustfmt-preview; };

        naersk-lib = (naersk.lib."${system}".override {
          cargo = pkgs.cargo;
          rustc = pkgs.rustc;
        });

        hello-world = naersk-lib.buildPackage {
          pname = "hello-world";
          nativeBuildInputs = with pkgs; [ pkg-config gtk3 cairo cmake alsa-lib openssl python3 ];
          root = ./.;
        };


      in
      rec {
        packages.hello-world = hello-world;

        defaultPackage = hello-world;

        apps.hello-world = flake-utils.lib.mkApp {
          drv = hello-world;
        };
        defaultApp = apps.hello-world;

        devShell = import ./shell.nix { inherit pkgs; };
      });
}
