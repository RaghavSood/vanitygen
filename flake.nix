{
  description = "Bitcoin vanity address generator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "vanitygen";
          version = "0.21";

          src = ./.;

          buildInputs = with pkgs; [ openssl pcre ];

          installPhase = ''
            mkdir -p $out/bin
            cp vanitygen $out/bin
            cp keyconv $out/bin/vanitygen-keyconv
          '';
        };
      }
    );
}
