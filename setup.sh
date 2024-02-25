#!/bin/sh

REPOS_DIR=$HOME/repos
DOTFILES_DIR=$REPOS_DIR/test

# Temporarily install git if it isn't already
which git 2>/dev/null || nix-shell -p git
mkdir -p $REPOS_DIR

git clone https://github.com/cecilia-sanare/dotfiles $DOTFILES_DIR
ln -s $DOTFILES_DIR /etc/nixos
nixos-rebuild switch
