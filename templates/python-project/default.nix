{
  pkgs,
  project,
  python ? pkgs.python,
}:

let
  attrs = project.renderers.buildPythonPackage {
    inherit python;
  };
in

python.pkgs.buildPythonPackage attrs
