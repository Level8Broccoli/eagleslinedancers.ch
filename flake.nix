{
  description = "eagleslinedancers.ch development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/404cd360c2607bcfe8d05a7d5ae609d6605f7e22"; # pin at yarn version 1.22.10
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs
            pkgs.yarn
          ];
        };
      }
    );
}
