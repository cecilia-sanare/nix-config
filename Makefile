.DEFAULT_GOAL := run
HOST := vm

clean:
	rm -f *.qcow2 result

garbage:
	nix-env --delete-generations old
	nix-store --gc
	sudo nix-collect-garbage -d
	sudo nixos-rebuild boot

build: clean
	nixos-rebuild build-vm --flake .#${HOST} --fast -I nixpkgs=.

build-iso:
	nix build .#nixosConfigurations.iso.config.system.build.isoImage

run: build
	./result/bin/run-${HOST}-vm

switch:
ifdef DEPLOY_HOST
	sudo nixos-rebuild switch --flake .#${DEPLOY_HOST}
else
	sudo nixos-rebuild switch
endif