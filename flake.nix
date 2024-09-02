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

          cmakeBuildType = "Debug";
          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Debug"

          ];

          dontStrip = true;

          installPhase = ''
            mkdir -p $out/bin
            cp vanitygen $out/bin
            cp keyconv $out/bin/vanitygen-keyconv
          '';

          meta = with pkgs.lib; {
            description = "Bitcoin vanity address generator";
            longDescription = ''
              Vanitygen can search for exact prefixes or regular expression
              matches, so you can generate Bitcoin addresses that starts
              with the needed mnemonic.
              Vanitygen can generate regular bitcoin addresses, namecoin
              addresses, and testnet addresses.
              When searching for exact prefixes, vanitygen will ensure that
              the prefix is possible, will provide a difficulty estimate,
              and will run about 30% faster.
            '';
            homepage = "https://github.com/samr7/vanitygen";
            # license = licenses.agpl3;
            platforms = platforms.all;
          };
        };
      }
    );
}
