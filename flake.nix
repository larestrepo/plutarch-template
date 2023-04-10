{
  description = "My Plutarch template";
  inputs = {
    haskellNix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ## See https://input-output-hk.github.io/cardano-haskell-packages/
    CHaP = {
      url = "github:input-output-hk/cardano-haskell-packages?ref=repo";
      flake = false;
    };
  };

  outputs = { self, haskellNix, nixpkgs, flake-utils, CHaP }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [ haskellNix.overlay
      (final: prev: {
        plutarch-template =
          final.haskell-nix.project' {
            src = ./.;
            compiler-nix-name = "ghc925";
            inputMap = {
              "https://input-output-hk.github.io/cardano-haskell-packages" = CHaP;
            };
            shell.tools = {
              cabal = {};
              hlint = {};
              hpack = {};
              haskell-language-server = {};
            };
          };
        })
      ];
    pkgs = import nixpkgs { inherit system overlays; inherit (haskellNix) config; };
    flake = pkgs.plutarch-template.flake {};
    in flake //
    {
      packages.default = flake.packages."plutarch-template:exe:plutarch-template";
    });

    nixConfig = {
      ## Setup IOG cache. See
      ## https://input-output-hk.github.io/haskell.nix/tutorials/getting-started.html#setting-up-the-binary-cache
      extra-experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
      extra-trusted-substituters = [
        "https://cache.nixos.org"
        "https://cache.iog.io"
        "https://cache.zw3rk.com"
        ];
      extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk="
        ];
      allow-import-from-derivation = "true";
      bash-prompt = "\\[\\e[0;92m\\][\\[\\e[0;92m\\]nix develop:\\[\\e[0;92m\\]\\w\\[\\e[0;92m\\]]\\[\\e[0;92m\\]$ \\[\\e[0m\\]";
    };
}