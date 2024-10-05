{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    pyproject-nix.url = "github:nix-community/pyproject.nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        { pkgs, ... }:
        let
          project = inputs.pyproject-nix.lib.project.loadPyproject {
            projectRoot = ./.;
          };
          python = pkgs.python312;

          change_me = pkgs.callPackage ./. { inherit python project; };
        in
        {
          devShells.default = pkgs.callPackage ./shell.nix { inherit python project; };

          packages = {
            inherit change_me;
            default = change_me;
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.ruff-format.enable = true;
            programs.ruff-check.enable = true;
            programs.taplo.enable = true;
            programs.actionlint.enable = true;
          };
        };
    };
}
