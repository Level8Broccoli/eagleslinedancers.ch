{
  description = "eagleslinedancers.ch development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-legacy.url = "github:NixOS/nixpkgs/404cd360c2607bcfe8d05a7d5ae609d6605f7e22"; # pin at yarn version 1.22.10
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-legacy,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        pkgs-legacy = import nixpkgs-legacy { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs-legacy.nodejs
            pkgs-legacy.yarn
          ];
        };

        packages.default =
          let
            # nix run nixpkgs#nix-prefetch-docker -- --image-name alpine --image-tag 3
            alpine = pkgs.dockerTools.pullImage {
              imageName = "alpine";
              imageDigest = "sha256:56fa17d2a7e7f168a043a2712e63aed1f8543aeafdcee47c58dcffe38ed51099";
              hash = "sha256-ZklI6Quz/DYp0JxNYuQTItmc9rp1Bob57frfk1BRpcA=";
              finalImageName = "alpine";
              finalImageTag = "3";
            };

            cms = pkgs.mkYarnPackage {
              src = ./cms;
            };
          in
          pkgs.dockerTools.buildLayeredImage {
            name = "eagles-cms";
            tag = "0.0.1";

            fromImage = alpine;
            contents = [
              pkgs.coreutils
              pkgs.bash
              cms
            ];

            config = {
              WorkingDir = "/libexec/cms/deps/cms";
              Cmd = [
                "${pkgs-legacy.yarn}/bin/yarn"
                "--offline"
                "start"
              ];
            };
          };
      }
    );
}
