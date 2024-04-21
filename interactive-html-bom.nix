{ lib
, python3
, fetchFromGitHub
}:
python3.pkgs.buildPythonApplication rec {
  pname = "interactive-html-bom";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openscopeproject";
    repo = "InteractiveHtmlBom";
    rev = "v${version}";
    hash = "sha256-jUHEI0dWMFPQlXei3+0m1ruHzpG1hcRnxptNOXzXDqQ=";
  };

  nativeBuildInputs = [
    python3.pkgs.hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    jsonschema
    wxpython
    kicad
  ];

  pythonImportsCheck = [ "InteractiveHtmlBom" ];

  meta = with lib; {
    description = "Interactive HTML BOM generation plugin for KiCad, EasyEDA, Eagle, Fusion360 and Allegro PCB designer";
    homepage = "https://github.com/openscopeproject/InteractiveHtmlBom";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "interactive-html-bom";
  };
}
