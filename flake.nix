{
  description = "eagleslinedancers.ch development environment";

  inputs = {
    nixpkgs-yarn.url = "github:NixOS/nixpkgs/404cd360c2607bcfe8d05a7d5ae609d6605f7e22"; # pin at yarn version 1.22.10
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs-yarn,
      # nixpkgs-unstable,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs-yarn { inherit system; };
      in
      # pkgs = import nixpkgs-unstable { inherit system; };
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs
            pkgs.yarn
          ];
        };

        packages = rec {
          default = cms2;

          cms = pkgs.mkYarnPackage {
            src = ./cms;

            nativeBuildInputs = [
              pkgs.python39Packages.pyvips
              pkgs.pkg-config
            ];

            buildInputs = [
              pkgs.python39Packages.pyvips
              pkgs.pkg-config
            ];

            buildPhase = ''
              export HOME=$(mktemp -d)
              export NODE_ENV=production
              ${pkgs.yarn}/bin/yarn --offline build
            '';

            # installPhase = ''
            # ${pkgs.yarn}/bin/yarn --offline start
            # '';
          };

          cms2 = pkgs.stdenv.mkDerivation (finalAttrs: {
            pname = "eagles-cms";
            version = "0.0.1";

            src = ./cms;

            yarnOfflineCache = pkgs.fetchYarnDeps {
              yarnLock = finalAttrs.src + "/yarn.lock";
              hash = "sha256-Y/D2negye2IA40heckixEWl/eDw8k9f50nfRX6giXsY=";
            };

            nativeBuildInputs = with pkgs; [
              yarnConfigHook
              yarnBuildHook
              yarnInstallHook
              nodejs
            ];
          });
        };
      }
    );
}
