#!/bin/bash

timeout=60
sec=$timeout

while [ $sec -ge 0 ]
do
	echo $(expr \( \( $timeout - $sec \) \* 100 / $timeout \) )
	echo "#This system will be automatically shut down in $sec seconds."
	let sec--
	sleep 1
done | GTK_THEME="Yad-Shutdown" yad --buttons-layout=center --skip-taskbar --undecorated --title="yad-shutdown" --on-top --button="Shutdown" --button="Reboot:3" --button="Suspend:9" --button="Lock:5" --button="Logout:7" --button="Cancel:1" --progress --center --auto-close

ret=$?

if [ $ret -eq 0 ]; then
	dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 "org.freedesktop.login1.Manager.PowerOff" boolean:true
fi
if [ $ret -eq 3 ]; then
	dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 "org.freedesktop.login1.Manager.Reboot" boolean:true
fi
if [ $ret -eq 5 ]; then
	gnome-screensaver-command -l
fi
if [ $ret -eq 7 ]; then
	gnome-session-quit --logout --no-prompt
fi
if [ $ret -eq 9 ]; then
	dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 "org.freedesktop.login1.Manager.Suspend" boolean:true
fi

