# Ceci's NixOS & Home Manager Configurations

These computers are managed by this Nix flake ❄️

|  Hostname   |                Board                |            CPU            | RAM  |       Primary GPU        | Secondary GPU | Role | OS  | State |
| :---------: | :---------------------------------: | :-----------------------: | :--: | :----------------------: | :-----------: | :--: | :-: | :---: |
| `phantasm`  |      [Z690-A][Phantasm-Board]       | [i6-12700K][Phantasm-CPU] | 32GB | [RTX 3080][Phantasm-GPU] | Intel UHD 770 |  🖥️  | ❄️  |  ✅   |
|  `spectre`  | [Macbook Air M1 13"][Spectre-Board] |    Apple M1 8-core CPU    | 16GB |   Apple M1 8-core GPU    |      N/A      | 💻️  | 🍏  |  🚧   |
| `polymorph` |     [Z170 Pro][Polymorph-Board]     | [i5-9600][Polymorph-CPU]  | 16GB |      Intel UHD 630       |      N/A      |  ☁️  | ❄️  |  🚧   |

**Key**

- 🖥️ : Desktop
- ☁️ : Server

## Quick Start

Running the command below _should_ just download and run my NixOS config, however its fairly opinionated on where it puts it!

I encourage you to fully understand the ramifications of running this before you do so.
This is here to simplify the setup process for _me_ first and foremost.

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/cecilia-sanare/dotfiles/main/setup.sh)" -s phantasm
```

<!-- Phantasm Links -->

[Phantasm-Board]: https://rog.asus.com/us/motherboards/rog-strix/rog-strix-z690-a-gaming-wifi-d4-model/spec/
[Phantasm-CPU]: https://www.intel.com/content/www/us/en/products/sku/134594/intel-core-i712700k-processor-25m-cache-up-to-5-00-ghz/specifications.html
[Phantasm-GPU]: https://www.gigabyte.com/Graphics-Card/GV-N3080VISION-OC-10GD-rev-20/sp#sp

<!-- Spectre Links -->

[Spectre-Board]: https://support.apple.com/kb/SP825

<!-- Polymorph Links -->

[Polymorph-Board]: https://motherboarddb.com/motherboards/729/Z170-Pro/
[Polymorph-CPU]: https://www.intel.com/content/www/us/en/products/sku/134900/intel-core-i59600-processor-9m-cache-up-to-4-60-ghz/specifications.html
