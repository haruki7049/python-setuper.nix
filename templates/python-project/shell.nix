{
  pkgs,
  project,
  python ? pkgs.python,
}:

let
  pythonEnv = python.withPackages (project.renderers.withPackages { inherit python; });
in

pkgs.mkShell {
  packages = [
    pkgs.nil
    pkgs.ruff
    pythonEnv
  ];

  shellHook = ''
    export PS1="\n[nix-shell:\w]$ "
  '';
}
