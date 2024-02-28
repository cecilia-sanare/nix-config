#!/bin/sh

set -e

if [ $UID -eq 0 ]; then
    echo "This script should *NOT* be run as sudo!"
    exit 1
fi

HOST=${1:-$(uname -n)}

REPOS_DIR=$HOME/repos
REPO_DIR=$REPOS_DIR/nix-config
HOST_DIR=$REPO_DIR/hosts/$HOST

# Temporarily install git if it isn't already
which git > /dev/null 2>&1 || nix-shell -p git
mkdir -p $REPOS_DIR > /dev/null

if [ ! -d "$REPO_DIR" ]; then
    echo "Pulling down repo..."
    git clone https://github.com/cecilia-sanare/nix-config $REPO_DIR > /dev/null
else
    echo "Repo detected, skipping clone"
    git -C $REPO_DIR remote set-url origin https://github.com/cecilia-sanare/nix-config
fi

if [ ! -e "$HOST_DIR/hardware-configuration.nix" ]; then
    echo "Unable to locate hardware config, pulling from NixOS..."
    sudo cp /etc/nixos/hardware-configuration.nix $HOST_DIR/hardware-configuration.nix
fi

if [ -d "/etc/nixos" ]; then
    echo "/etc/nixos detected, removing to replace with symlink..."
    sudo rm -rf /etc/nixos > /dev/null
fi

echo "Creating symlink..."
sudo ln -s $REPO_DIR /etc/nixos > /dev/null
sudo nixos-rebuild switch --flake .#${HOST}

# # Update the origin to the SSH version now that we're all setup!
git -C $REPO_DIR remote set-url origin git@github.com:cecilia-sanare/nix-config.git