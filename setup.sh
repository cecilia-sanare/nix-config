#!/usr/bin/env sh

set -e

if [ $UID -eq 0 ]; then
    echo "This script should *NOT* be run as sudo!"
    exit 1
fi

command -v nix >/dev/null 2>&1 || { echo >&2 "Nix is not installed. Aborting."; exit 1; }

HOST=${1:-$(uname -n)}
OS=$(uname -o)

REPOS_DIR=$HOME/repos
REPO_DIR=$REPOS_DIR/nix-config

if [ $OS = "GNU/Linux" ]; then
    HOST_DIR=$REPO_DIR/platform/nixos/$HOST
elif [ $OS = "Darwin" ]; then
    HOST_DIR=$REPO_DIR/platform/nix-darwin/$HOST
else
    echo 2> "Unknown OS! ($OS)"
    exit 1
fi


mkdir -p $REPOS_DIR > /dev/null

if [ ! -d "$REPO_DIR" ]; then
    echo "Pulling down repo..."
    nix-shell -p git --run "git clone https://github.com/cecilia-sanare/nix-config $REPO_DIR" > /dev/null
    # Update the origin to the SSH version now that we're all setup!
    nix-shell -p git --run "git -C $REPO_DIR remote set-url origin git@github.com:cecilia-sanare/nix-config.git" > /dev/null
else
    echo "Repo detected, skipping clone"
fi

cd $REPO_DIR

if [ -d "/etc/nixos" ]; then
    if [ ! -e "$HOST_DIR/hardware.nix" ]; then
        echo "Unable to locate hardware config, pulling from NixOS..."
        sudo cp /etc/nixos/hardware-configuration.nix $HOST_DIR/hardware.nix
    fi

    echo "/etc/nixos detected, removing to replace with symlink..."
    sudo rm -rf /etc/nixos > /dev/null
    echo "Creating symlink..."
    sudo ln -s $REPO_DIR /etc/nixos > /dev/null
fi

if [ $OS = "GNU/Linux" ]; then
    if [ -z "$(command -v nix)" ]; then
        sudo nixos-rebuild switch --flake .#${HOST}
    else
        # Pretty sure this is right, but honestly not sure
        sudo nix build .#nixosConfigurations.${HOST}.config.system.build.toplevel
    fi
elif [ $OS = "Darwin" ]; then
    if [ -z "$(command -v darwin-rebuild)" ]; then
        darwin-rebuild switch --flake .#${HOST}
    else
        nix run nix-darwin -- switch --flake .#${HOST}
    fi
else
    echo 2> "Unknown OS! ($OS)"
    exit 1
fi

if [ $HOST = "polymorph" ]; then
    touch /home/kodi/acme.json
    sudo chown kodi:users /home/kodi/acme.json
    sudo chmod 600 /home/kodi/acme.json
fi