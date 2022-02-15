{
  description = "iamy";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in rec {
          defaultPackage = pkgs.buildGoModule rec {
            pname = "iamy";
            version = "3.3.0";
          
            src = pkgs.fetchFromGitHub {
              owner = "envato";
              repo = "iamy";
              rev = "v${version}";
              sha256 = null;
            };
          
            vendorSha256 = null;

            proxyVendor = true;
            
            doCheck = false;
          
            ldflags = [
              "-X main.Version=v${version}+envato" "-s" "-w"
            ];
          
            meta = with pkgs.lib; {
              description = "A cli tool for importing and exporting AWS IAM configuration to YAML files";
              homepage = "https://github.com/99designs/iamy";
              license = licenses.mit;
            };
          };

          apps = {
            iamy = {
              type = "app";
              program = "${defaultPackage.${system}}/bin/iamy";
            };
          };

          defaultApp = apps.${system}.iamy;
        }
      );
}
