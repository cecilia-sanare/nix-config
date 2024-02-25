.DEFAULT_GOAL := build

build:
	sudo nixos-rebuild switch

cleanup:
	sudo nix-collect-garbage --delete-older-than 1d && sudo nixos-rebuild boot

history:
	sudo nix profile history --extra-experimental-features nix-command --profile /nix/var/nix/profiles/system