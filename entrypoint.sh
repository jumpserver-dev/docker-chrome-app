#!/usr/bin/env bash

# Default configurations
SCREEN_WIDTH=${JUMPSERVER_WIDTH:-1280}
SCREEN_HEIGHT=${JUMPSERVER_HEIGHT:-800}
GEOMETRY="${SCREEN_WIDTH}""x""${SCREEN_HEIGHT}"
DEPTH="${JUMPSERVER_DEPTH:-24}"
DPI="${JUMPSERVER_DPI:-96}"

# Create VNC config directory
mkdir -p "${HOME:-/root}/.vnc"
# Set VNC password
if [ -z "${JMS_VNC_PASSWORD}" ]; then
    JMS_VNC_PASSWORD=$(head -c100 < /dev/urandom | base64 | tr -dc A-Za-z0-9 | head -c 8; echo)
    echo "Generated VNC password: ${JMS_VNC_PASSWORD}"
fi

# Store VNC password
echo "${JMS_VNC_PASSWORD}" | vncpasswd -f > "${HOME:-/root}/.vnc/passwd"
chmod 600 "${HOME:-/root}/.vnc/passwd"

# Configure xstartup for IME and clipboard support
cat > "${HOME:-/root}/.vnc/xstartup" <<EOF
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# Start DBus
dbus-launch --exit-with-session &

export DISPLAY=:0
# Start iBus for Chinese input
export XMODIFIERS="@im=ibus"
export GTK_IM_MODULE="xim"
export QT_IM_MODULE="ibus"


export LIBGL_ALWAYS_SOFTWARE=1
export GALLIUM_DRIVER=llvmpipe
export CHROME_DISABLE_GPU=1


export XDG_SESSION_TYPE=x11
export WINDOW_MANAGER=openbox


# Window manager
openbox-session &

# Wait for window manager
sleep 2


# ibus-daemon -drx

# # Start clipboard manager
# autocutsel -fork
# autocutsel -selection PRIMARY -fork


exec /opt/py3/bin/python /opt/app/main.py
EOF
chmod +x "${HOME:-/root}/.vnc/xstartup"

# Start TigerVNC server with clipboard support
exec /usr/bin/vncserver :0 \
    -geometry ${GEOMETRY} \
    -depth ${DEPTH} \
    -dpi ${DPI} \
    -localhost no \
    -passwd "${HOME:-/root}/.vnc/passwd" \
    -fg \
    -SecurityTypes VncAuth \
    # +extension XFIXES \
    -clipboard \
    "$@"