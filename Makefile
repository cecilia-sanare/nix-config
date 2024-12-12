.DEFAULT_GOAL := run
HOST := vm

# #####################
# Build Utilities ####
# ###################

clean:
	rm -f *.qcow2 result

build: clean update
	nixos-rebuild build-vm --flake .#${HOST} --fast -I nixpkgs=. --show-trace

build-iso:
	nix build .#nixosConfigurations.iso.config.system.build.isoImage

run: build
	./result/bin/run-${HOST}-vm

# ##################################
# Garbage Collecting Utilities ####
# ################################

# This deletes EVERYTHING that is old!
garbage-full: garbage-base
	nix-env --delete-generations old
	sudo nix-collect-garbage -d
	sudo nixos-rebuild boot

# This deletes EVERYTHING within the last 10 days that is old!
garbage-safe: garbage-base
	nix-env --delete-generations 10d
	sudo nix-collect-garbage --delete-older-than 10d
	sudo nixos-rebuild boot

garbage-base:
	nix-store --gc

# #######################
# Switch Utilities ####
# ###################

switch: switch-base
switch-full: garbage-full switch-base garbage-full
switch-safe: garbage-safe switch-base garbage-safe

switch-base: update
ifdef DEPLOY_HOST
	sudo nixos-rebuild switch --flake .#${DEPLOY_HOST} --show-trace --option eval-cache false
else
	sudo nixos-rebuild switch --show-trace --option eval-cache false --impure
endif
	@nix-shell -p fish --run "./refresh-desktop.fish"

# ######################
# Update Utilities ####
# ####################

update:
	@nix flake update nix-desktop protontweaks

update-nix:
	@nix flake update nixpkgs nixpkgs-master nixpkgs-stable home-manager
