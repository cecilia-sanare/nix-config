# .dotfiles

Welcome to my dotfiles!

Although... its not really a dotfiles repo anymore!
I run linux now and more specifically NixOS!
So here's my setup!

## Quick Start

Running the command below *should* just download and run my NixOS config, however its fairly opinionated on where it puts it!

I encourage you to fully understand the ramifications of running this before you do so.
This is here to simplify the setup process for *me* first and foremost.

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/cecilia-sanare/dotfiles/main/setup.sh)"
```

## Manual Bits

### 1Password (SSH Agent)

- Login > Settings > Developer
- Set Up SSH Agent
- Use Key Names
- Remember key approval: until 1Password quits