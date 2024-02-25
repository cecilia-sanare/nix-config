{ lib, config, ... }: 

with lib;

let
  cfg = config.dotfiles.intl;
  # TODO: Is there any way to infer this from time.timeZone?
  nospace  = str: filter (c: c == " ") (stringToCharacters str) == [];
  timezone = types.nullOr (types.addCheck types.str nospace);
in {
  options.dotfiles.intl = {
    timeZone = mkOption {
      type = timezone;
      default = "America/Chicago";
    };
    locale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
    };
  };

  config = {
    # Set your time zone.
    time.timeZone = cfg.timeZone;

    # Select internationalisation properties.
    i18n.defaultLocale = cfg.locale;

    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.locale;
      LC_IDENTIFICATION = cfg.locale;
      LC_MEASUREMENT = cfg.locale;
      LC_MONETARY = cfg.locale;
      LC_NAME = cfg.locale;
      LC_NUMERIC = cfg.locale;
      LC_PAPER = cfg.locale;
      LC_TELEPHONE = cfg.locale;
      LC_TIME = cfg.locale;
    };
  };
}
