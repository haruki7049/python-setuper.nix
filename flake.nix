{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.nil
              pkgs.nixpkgs-fmt
            ];

            shellHook = ''
              export PS1="\n[nix-shell:\w]$ "
            '';
          };

          treefmt = {
            projectRootFile = "flake.lock";
            programs.nixfmt.enable = true;
            programs.mdformat.enable = true;
            programs.black.enable = true;
            programs.taplo.enable = true;
            programs.actionlint.enable = true;
          };
        };
    };
}
