# Displays info when running `just` without subcommand
default:
    @just --list

update:
    git pull --rebase
    nix flake update --flake ./.nix-env
