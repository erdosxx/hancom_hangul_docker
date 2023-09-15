#!/bin/sh

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

if ! pgrep -x "ibus-daemon" > /dev/null
then
ibus-daemon -drx
fi

# Set Korean input with toggling key <F8>
dconf load /desktop/ibus/ < /root/ibus.dconf
# Fix to hangul input bug: https://hamonikr.org/board_bFBk25/98079 
gsettings set org.freedesktop.ibus.engine.hangul use-event-forwarding false
/opt/hnc/hoffice11/Bin/hwp "$@"
