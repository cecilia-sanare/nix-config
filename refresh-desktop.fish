#!/usr/bin/env fish

# set DESKTOP = $DESKTOP_SESSION or "unknown"
set -q DESKTOP_SESSION; or set DESKTOP_SESSION unknown
set DESKTOP $DESKTOP_SESSION

switch $DESKTOP
    case plasmax11
        set DESKTOP plasma
end

if test "$DESKTOP" = "plasma"
    kstart "plasmashell" -- --replace > /dev/null 2>&1
    echo "Plasma restarted successfully!"
else if test "$DESKTOP" = "gnome"
    printf %b\n \
        "Gnome is generally well behaved and doesn't require restarting, however the following command may be ran if necessary...\n" \
        "   \$ killall -3 gnome-shell"
else
    echo "Unknown desktop environment! ($DESKTOP)"
    exit 1
end