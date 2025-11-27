#!/usr/bin/env bash

# install nix
nix-env --version > /dev/null \
    || curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install \
    | sh --daemon 

# set experminetal features
[ -d "/etc/nix" ] || sudo mkdir -p "/etc/nix"
sudo fgrep experimental-features "/etc/nix/nix.conf" 2> /dev/null  || cat <<EOF | sudo tee -a "/etc/nix/nix.conf"
experimental-features = nix-command flakes
EOF

# get config
[ -d "$HOME/.config/" ] || mkdir -p "$HOME/.config/"
[ -d "$HOME/.config/home-manager" ] || nix run nixpkgs#git -- \
    clone https://github.com/Westixy/simple-home-manager-init.git \
    "$HOME/.config/home-manager"

sed -i "s/auberge/$USER/g" "$HOME/.config/home-manager/home.nix"
sed -i "s/auberge/$USER/g" "$HOME/.config/home-manager/flake.nix"

# initialise home manager
nix run nixpkgs#nh -- home switch "$HOME/.config/home-manager"
