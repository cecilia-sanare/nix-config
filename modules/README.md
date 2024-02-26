## NixOS Modules

- [`dotfiles.audio`](#dotfilesaudio-source) ([source](./audio/default.nix))
- [`dotfiles.containers`](#dotfilescontainers-source) ([source](./containers/default.nix))
- [`dotfiles.desktop`](#dotfilesdesktop-source) ([source](./desktop/default.nix))
- [`dotfiles.displays`](#dotfilesdisplays-source) ([source](./displays/default.nix))
- [`dotfiles.gpu`](#dotfilesgpu-source) ([source](./gpu/default.nix))
- [`dotfiles.intl`](#dotfilesintl-source) ([source](./intl/default.nix))
- [`dotfiles.network`](#dotfilesnetwork-source) ([source](./network/default.nix))
- [`dotfiles.storage`](#dotfilesstorage-source) ([source](./storage/default.nix))
- [`dotfiles.users`](#dotfilesusers-source) ([source](./users/default.nix))

### `dotfiles.audio` ([source](./audio/default.nix))

```nix
{
    # ...
    dotfiles = {
        # ...
        audio = {
            enable = true;          # defaults to false
            server = "pulseaudio";  # defaults to pipewire
            
            goxlr = {
                enable = true;      # defaults to false
                profile = ./MyProfile.goxlr;
                micProfile = ./MyMicProfile.goxlrMicProfile;
            };
        };
    };
}
```

### `dotfiles.containers` ([source](./containers/default.nix))

```nix
{
    # ...
    dotfiles = {
        # ...
        containers = {
            enable = true;      # defaults to false
            tool = "docker";    # defaults to podman
            discovery = true;   # defaults to true
        };
    };
}
```

### `dotfiles.desktop` ([source](./desktop/default.nix))

```nix
{
    # ...
    dotfiles = {
        # ...
        desktop = {
            enable = true;                  # defaults to false
            protocol = ["xorg" "wayland"];  # defaults to xorg only
            environment = "gnome";          # defaults to gnome
            sleep = false;                  # defaults to true
        };
    };
}
```

### `dotfiles.displays` ([source](./displays/default.nix))

```nix
{
    # ...
    dotfiles = {
        # ...
        displays = [
            {
                # Run 'autorandr --fingerprint' to get these values
                name = "DP-1";                  # autorandr output name
                fingerprint = "<fingerprint>";  # autorandr fingerprint

                primary = true;                 # defaults to false

                resolution = "2560x1440";
                position = "2560x0";
                rate = "144.01";
            }
        ];
    };
}
```

### `dotfiles.gpu` ([source](./gpu/default.nix))

```nix
{
    # ...
    dotfiles = {
        # ...
        gpu = {
            enable = true;  # defaults to false
            vendor = "amd"; # defaults to null
        };
    };
}
```

### `dotfiles.intl` ([source](./intl/default.nix))

```nix
{
    # ...
    dotfiles = {
        # ...
        intl = {
            timeZone = "America/NewYork";   # defaults to 'America/Chicago'
            locale = "en_US.UTF-8";         # defaults to 'en_US.UTF-8'
        };
    };
}
```

### `dotfiles.network` ([source](./network/default.nix))

```nix
{
    # ...
    dotfiles = {
        # ...
        network = {
            enable = true;          # defaults to false
            hostName = "cecis-pc";  # defaults to 'nixos'
            wifi = true;            # defaults to false
            printing = true;        # defaults to false
        };
    };
}
```

### `dotfiles.storage` ([source](./storage/default.nix))

```nix
{
    # ...
    dotfiles = {
        # ...
        storage = {
            enable = true;  # defaults to false
            type = "ssd";   # enables optimizations based upon what's present
        };
    };
}
```

### `dotfiles.users` ([source](./users/default.nix))

> This will probably get reworked heavily at some point since it kinda got everything thrown into it

```nix
{
    # ...
    dotfiles = {
        # ...
        users.default = {
            # Anything placed in here will apply to all users
            shell = "zsh";
        };

        users.ceci = {
            name = "Cecilia Sanare";
        };
    };
}
```