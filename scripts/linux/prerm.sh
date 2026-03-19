#!/bin/bash
# BuSic prerm script - runs before package removal
# This script is executed by dpkg before the package is removed

set -e

# Package name
APP_NAME="busic"

# Remove desktop entry
remove_desktop_entry() {
    rm -f "/usr/share/applications/${APP_NAME}.desktop"
    
    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        update-desktop-database /usr/share/applications 2>/dev/null || true
    fi
}

# Remove icons
remove_icons() {
    local icon_dir="/usr/share/icons/hicolor"
    
    # Remove icon files for various sizes
    for size in 16x16 22x22 24x24 32x32 48x48 64x64 128x128 256x256 512x512; do
        rm -f "${icon_dir}/${size}/apps/${APP_NAME}.png"
    done
    
    # Remove from gnome icon theme
    rm -f "/usr/share/icons/gnome/256x256/apps/${APP_NAME}.png"
    
    # Clean up empty directories
    rmdir "${icon_dir}/16x16/apps" "${icon_dir}/22x22/apps" "${icon_dir}/24x24/apps" \
          "${icon_dir}/32x32/apps" "${icon_dir}/48x48/apps" "${icon_dir}/64x64/apps" \
          "${icon_dir}/128x128/apps" "${icon_dir}/256x256/apps" "${icon_dir}/512x512/apps" 2>/dev/null || true
    
    # Update icon cache
    if command -v gtk-update-icon-cache &> /dev/null; then
        gtk-update-icon-cache -f -t /usr/share/icons/hicolor 2>/dev/null || true
    fi
}

# Remove symbolic link
remove_symlink() {
    rm -f "/usr/bin/${APP_NAME}"
}

# Main execution
case "$1" in
    remove|purge)
        remove_desktop_entry
        remove_icons
        remove_symlink
        ;;
    upgrade|failed-upgrade)
        # Do nothing on upgrade
        ;;
    deconfigure)
        # Do nothing on deconfigure
        ;;
    *)
        ;;
esac

exit 0
