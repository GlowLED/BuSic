#!/bin/bash
# BuSic postinst script - runs after package installation
# This script is executed by dpkg after the package is installed

set -e

# Package name
APP_NAME="busic"

# Install icons for desktop environments
install_icons() {
    local icon_dir="/usr/share/icons/hicolor"
    
    # Create icon directories for various sizes
    for size in 16x16 22x22 24x24 32x32 48x48 64x64 128x128 256x256 512x512; do
        mkdir -p "${icon_dir}/${size}/apps"
        if [ -f "/opt/${APP_NAME}/data/flutter_assets/assets/images/app_icon.png" ]; then
            cp "/opt/${APP_NAME}/data/flutter_assets/assets/images/app_icon.png" \
               "${icon_dir}/${size}/apps/${APP_NAME}.png"
        fi
    done
    
    # Also install to gnome icon theme
    mkdir -p /usr/share/icons/gnome/256x256/apps
    if [ -f "/opt/${APP_NAME}/data/flutter_assets/assets/images/app_icon.png" ]; then
        cp "/opt/${APP_NAME}/data/flutter_assets/assets/images/app_icon.png" \
           "/usr/share/icons/gnome/256x256/apps/${APP_NAME}.png"
    fi
    
    # Update icon cache
    if command -v gtk-update-icon-cache &> /dev/null; then
        gtk-update-icon-cache -f -t /usr/share/icons/hicolor 2>/dev/null || true
    fi
}

# Create desktop entry
create_desktop_entry() {
    local desktop_file="/usr/share/applications/${APP_NAME}.desktop"
    
    cat > "${desktop_file}" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=BuSic
GenericName=Music Player
Comment=A high-quality cross-platform music player
Exec=/opt/${APP_NAME}/${APP_NAME} %U
Icon=${APP_NAME}
Terminal=false
Categories=Audio;Music;Player;AudioVideo;
Keywords=music;audio;player;bilibili;busi;
MimeType=audio/mpeg;audio/flac;audio/ogg;audio/wav;
StartupNotify=true
StartupWMClass=busic
EOF
    
    chmod 644 "${desktop_file}"
    
    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        update-desktop-database /usr/share/applications 2>/dev/null || true
    fi
}

# Create symbolic link in PATH
create_symlink() {
    if [ -f "/opt/${APP_NAME}/${APP_NAME}" ]; then
        ln -sf "/opt/${APP_NAME}/${APP_NAME}" "/usr/bin/${APP_NAME}"
    fi
}

# Main execution
case "$1" in
    configure|triggered)
        install_icons
        create_desktop_entry
        create_symlink
        ;;
    abort-upgrade|abort-remove|abort-deconfigure)
        # Do nothing on these triggers
        ;;
    *)
        ;;
esac

exit 0
