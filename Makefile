.DEFAULT_GOAL := build

build:
	sudo nixos-rebuild switch

build-verbose:
	sudo nixos-rebuild switch -v

cleanup:
	sudo nix-collect-garbage --delete-older-than 1d && sudo nixos-rebuild boot

cleanup-all:
	sudo nix-collect-garbage --delete-old && sudo nixos-rebuild boot

history:
	sudo nix profile history --extra-experimental-features nix-command --profile /nix/var/nix/profiles/system