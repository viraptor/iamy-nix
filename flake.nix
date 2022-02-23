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
            version = "4.0.0";
          
            src = pkgs.fetchFromGitHub {
              owner = "envato";
              repo = "iamy";
              rev = "v4.0.0";
              sha256 = "sha256-VvveRJogeNnwvYtyqa7f8n2s4FLQoZJiLMJo5Przp18=";
            };
          
            vendorSha256 = "sha256-joVNR5pqkYNd9HQ4retqvj1RfdkluSdsfrSVnMtLans=";

            proxyVendor = true;
            
            doCheck = false;
          
            ldflags = [
              "-X main.Version=v${version}+envato" "-s" "-w"
            ];
          
            meta = with pkgs.lib; {
              description = "A cli tool for importing and exporting AWS IAM configuration to YAML files";
              homepage = "https://github.com/envato/iamy";
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
