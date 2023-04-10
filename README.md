# Plutarch Template

Plutarch template is based on [Hello Plutarch](https://github.com/tweag/hello-plutarch)

You need Nix installed

With the nixConfig section in flakes there's no need to make changes in the global config file. In case this option does not work, modify the nix.conf file as follows.

Edit nix.conf file to decrease the amount of time for building. In case of not having /etc/nix/nix.confg create ~/.config/nix/nix.conf instead. Add the following lines:

    experimental-features = nix-command flakes ca-derivations
    substituters = https://cache.nixos.org https://cache.iog.io https://cache.zw3rk.com
    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk=
    allow-import-from-derivation = true

Restart nix service and confirm that the changes were taken by nix by printing the config and looking at the substituters and truested-public keys; they should correspond to the previous configuration:

    nix show-config

### Steps to configure

    nix develop
    cabal update
    cabal build
    cabal run

### Some useful commands

    nix develop --show-trace
    nix develop --accept-flake-config
    nix show-config
    nix-store --gc
