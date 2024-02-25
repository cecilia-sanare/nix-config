## NixOS Modules

- [`dotfiles.intl`](#dotfilesintl)
- [`dotfiles.desktop`](#dotfilesdesktop)
- [`dotfiles.containers`](#dotfilescontainers)

### `dotfiles.intl`

```nix
{
    # ...
    dotfiles = {
        # ...
        intl = {
            timeZone = "America/NewYork"; # Defaults to America/Chicago
            locale = "en_US.UTF-8"; # Defaults to en_US.UTF-8
        };
    };
}
```

### `dotfiles.desktop`

```nix
{
    # ...
    dotfiles = {
        # ...
        desktop = {
            enable = true; # defaults to false
            protocol = ["xorg" "wayland"]; # defaults to xorg only
            environment = "gnome"; # defaults to gnome
        };
    };
}
```

### `dotfiles.containers`

```nix
{
    # ...
    dotfiles = {
        # ...
        containers = {
            enable = true; # defaults to false
            tool = "docker"; # defaults to podman
            discovery = true; # defaults to true
        };
    };
}
```