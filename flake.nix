{
  description = "Apply lightmaps to Razer devices";

  nixConfig.bash-prompt = "\[\\e[1m\\e[32mrzr-develop\\e[0m\]$ ";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {

          # Package

          packages.rzr =

            pkgs.python3Packages.buildPythonApplication rec {

              name = "rzr";
              src = self;

              nativeBuildInputs = with pkgs; [
                wrapGAppsHook
              ];
              
              propagatedBuildInputs = with pkgs; [
                python3Packages.colour
                python3Packages.openrazer
                python3Packages.toml
              ];
              
            };

          defaultPackage = self.packages.${system}.rzr;

          # Development shell

          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              python3
              python3Packages.pip
              python3Packages.virtualenv
              python3Packages.colour
              python3Packages.openrazer
              python3Packages.toml
            ];
            shellHook = ''
              if [ ! -d .venv ]; then
                python -m venv .venv
              fi
              source .venv/bin/activate
              pip install --upgrade pip
              pip install -r requirements.txt
            '';
          };

        }

      );
}
