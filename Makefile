.DEFAULT_GOAL := build

build:
	sudo nixos-rebuild switch

history:
	sudo nix profile history --extra-experimental-features nix-command --profile /nix/var/nix/profiles/system