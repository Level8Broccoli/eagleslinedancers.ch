{
  description = "eagleslinedancers.ch development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-legacy.url = "github:NixOS/nixpkgs/404cd360c2607bcfe8d05a7d5ae609d6605f7e22"; # pin at yarn version 1.22.10
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      # nixpkgs,
      nixpkgs-legacy,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # pkgs = import nixpkgs { inherit system; };
        pkgs = import nixpkgs-legacy { inherit system; };
      in
      # pkgs =pkgs;
      #pkgs = pkgs;
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs
            pkgs.yarn
          ];
        };

        packages.default =
          let
            # nix run nixpkgs#nix-prefetch-docker -- --image-name alpine --image-tag 3
            alpine = pkgs.dockerTools.pullImage {
              imageName = "alpine";
              imageDigest = "sha256:56fa17d2a7e7f168a043a2712e63aed1f8543aeafdcee47c58dcffe38ed51099";
              # hash = "sha256-ZklI6Quz/DYp0JxNYuQTItmc9rp1Bob57frfk1BRpcA=";
              sha256 = "sha256-C3TOcLa18BKeBfS5FSe0H6BALGA/zXSwSZstK+VaPyo=";
            };

            cms = pkgs.mkYarnPackage {
              src = builtins.path {
                path = ./cms;
                filter = path: type: !(type == "directory" && baseNameOf path == "node_modules");
              };
              extraBuildInputs = [
                # pkgs.vips
                # pkgs.vips.dev
              ];

              pkgConfig =
                let
                  nodeHeaders = pkgs.fetchurl {
                    url = "https://nodejs.org/download/release/v${pkgs.nodejs.version}/node-v${pkgs.nodejs.version}-headers.tar.gz";
                    sha256 = "sha256-JPpqOSUCeYDjLPolVdHMnsqYnbbAiQ/h4S4cn570uqc=";
                  };
                in
                {
                  sharp = {
                    # nativeBuildInputs = builtins.attrValues {
                    #   inherit (pkgs.nodePackages) node-gyp;
                    #   inherit (pkgs) python3 pkg-config;
                    # };
                    buildInputs = [ pkgs.vips ];
                    postInstall = ''
                      export PYTHON=${pkgs.python3}/bin/python

                      ${pkgs.nodePackages.node-gyp}/bin/node-gyp \
                        rebuild --tarball="${nodeHeaders}"
                    '';
                  };
                };
              # pkgConfig = {
              #   sharp =
              #     let
              #       nodeHeaders =pkgs.fetchurl {
              #         name = "node-headers-${pkgs-legacy.nodejs.version}";
              #         url = "https://nodejs.org/download/release/v${pkgs-legacy.nodejs.version}/node-v${pkgs-legacy.nodejs.version}-headers.tar.gz";
              #         sha256 = "sha256-JPpqOSUCeYDjLPolVdHMnsqYnbbAiQ/h4S4cn570uqc=";
              #         # sha256 = "sha256-DULcOzN39J5JWXbcDk9cOn/7HXFAUNLyR6/bvAiY2uU=";
              #       };
              #     in
              #     {
              #       nativeBuildInputs = withpkgs; [
              #         pkgconfig
              #         pkg-config
              #         python3
              #         nodePackages.node-gyp
              #       ];
              #       buildInputs = withpkgs; [ vips ];

              #       # Add additional environment variables if needed
              #       NIX_CFLAGS_COMPILE = [ "-I${pkgs-legacy.glib.dev}/include" ];
              #       NIX_LDFLAGS = [ "-L${pkgs-legacy.glib.lib}" ];

              #       # Set the PKG_CONFIG_PATH to include pkg-config files for glib during build
              #       PKG_CONFIG_PATH = "${pkgs-legacy.glib.lib}/pkgconfig";

              #       postInstall = ''
              #         export PYTHON="${pkgs-legacy.python3}/bin/python"

              #         ${pkgs-legacy.nodePackages.node-gyp}/bin/node-gyp rebuild --tarball="${nodeHeaders}"
              #         ${pkgs-legacy.nodejs}/bin/node install/dll-copy
              #       '';
              #     };
              # };
            };
          in
          pkgs.dockerTools.buildLayeredImage {
            name = "eagles-cms";
            tag = "0.0.1";

            fromImage = alpine;
            contents = [
              pkgs.coreutils
              pkgs.bash
              # pkgs.nodejs
              # pkgs.vips
              cms
            ];

            config = {
              # Env = [
              # "SHARP_IGNORE_GLOBAL_LIBVIPS=1"
              # ];
              WorkingDir = "/libexec/cms/deps/cms";
              Cmd = [
                # "${pkgs.nodejs}/bin/npm"
                # "install"
                # "--ignore-scripts=false"
                # "--verbose"
                # "sharp"
                "${pkgs.yarn}/bin/yarn"
                "--offline"
                "start"
              ];
            };
          };
      }
    );
}
