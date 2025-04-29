# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ config, lib, libx, pkgs, ... }:
let
  inherit (lib) mkIf;
  variant = "firefox";
  package = {
    librewolf = pkgs.stable.librewolf;
    firefox = pkgs.stable.firefox;
    floorp = pkgs.stable.floorp;
  }.${variant};
in
mkIf libx.isLinux {
  home.shellAliases = mkIf (variant != "firefox") {
    "firefox" = variant;
  };

  programs.firefox = {
    enable = true;
    package = package;
    profiles.${config.home.username} = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        buster-captcha-solver
        clearurls
        onepassword-password-manager
        libredirect
        react-devtools
        reduxdevtools
        translate-web-pages
        ublock-origin
        refined-github
        sponsorblock
        violentmonkey
        # # Missing:
        # pwas-for-firefox
      ];

      search = {
        force = true;
        default = "Kagi";
        privateDefault = "Kagi";

        engines = {
          "Kagi" = {
            urls = [{
              template = "https://kagi.com/search";
              params = [
                { name = "q"; value = "{searchTerms}"; }
              ];
            }];

            definedAliases = [ "@k" ];
          };
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "Nix Options" = {
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
        };
      };

      settings = {
        # Vertical tabs and rounded content area
        "sidebar.sidebar" = true;
        "sidebar.sidebar.round-content-area" = true;
        "sidebar.verticalTabs" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;

        "browser.aboutConfig.showWarning" = false;
        "browser.tabs.tabmanager.enabled" = false;
        "browser.tabs.firefox-view" = false;

        # Performance settings
        "gfx.webrender.all" = true; # Force enable GPU acceleration
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes

        # Keep the reader button enabled at all times; really don't
        # care if it doesn't work 20% of the time, most websites are
        # crap and unreadable without this
        "reader.parse-on-load.force-enabled" = true;

        # Hide the "sharing indicator", it's especially annoying
        # with tiling WMs on wayland
        "privacy.webrtc.legacyGlobalIndicator" = false;

        # Actual settings
        "app.update.auto" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.contentblocking.category" = "strict";
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "browser.discovery.enabled" = false;
        "browser.laterrun.enabled" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" =
          false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" =
          false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
        "browser.newtabpage.activity-stream.section.highlights.includePocket" =
          false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.pinned" = false;
        "browser.protections_panel.infoMessage.seen" = true;
        "browser.quitShortcut.disabled" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.ssb.enabled" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.suggest.openpage" = false;
        "datareporting.policy.dataSubmissionEnable" = false;
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.pocket.enabled" = false;
        "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
        "services.sync.prefs.sync-seen.media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
        "identity.fxaccounts.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        "layers.acceleration.force-enabled" = true;
        "mozilla.widget.use-argb-visuals" = true;
      };
    };
  };
}
