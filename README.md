# Ceci's NixOS & Home Manager Configurations

These computers are managed by this Nix flake ❄️

|  Hostname   |            Board            |           CPU            | RAM  |  Primary GPU  | Secondary GPU | Role | OS  | State |
| :---------: | :-------------------------: | :----------------------: | :--: | :-----------: | :-----------: | :--: | :-: | :---: |
| `polymorph` | [Z170 Pro][Polymorph-Board] | [i5-9600][Polymorph-CPU] | 16GB | Intel UHD 630 |      N/A      |  ☁️  | ❄️  |  ✅   |

**Role Key**

- 🎭️ : Dual boot
- 🖥️ : Desktop
- 💻️ : Laptop
- ☁️ : Server

**OS Key**

- ❄️ : NixOS

## Prerequisites

- [Nix](https://nixos.org/download) _(not necessary if you're running NixOS)_

## Quick Start

Running the command below _should_ just download and run my NixOS config, however its fairly opinionated on where it puts it!

I encourage you to fully understand the ramifications of running this before you do so.
This is here to simplify the setup process for _me_ first and foremost.

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/cecilia-sanare/nix-config/main/setup.sh)" -s <hostname>
```

<!-- Polymorph Links -->

[Polymorph-Board]: https://motherboarddb.com/motherboards/729/Z170-Pro/
[Polymorph-CPU]: https://www.intel.com/content/www/us/en/products/sku/134900/intel-core-i59600-processor-9m-cache-up-to-4-60-ghz/specifications.html
