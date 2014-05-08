#!/bin/sh -x

echo "Starting preflight"
echo "Stopping user MenuBars"
pv=`sw_vers -productVersion`
# case $pv in
#	10.5.*)
		echo "Stopping root MenuBar (if exists)"
		# sudo launchctl unload /Library/LaunchAgents/com.logmein.hamachimb.plist
		launchctl unload /Library/LaunchAgents/com.logmein.hamachimb.plist
#		;;
#	*)
		SaveIFS=$IFS
		IFS="\n"
		for uisession in `ps axo "user pid command" | grep -v grep | grep loginwindow | tr -s ' ' | cut -f 1-2 -d' '`
		do
			uiusername=`echo $uisession | cut -f 1 -d' '`
			uipid=`echo $uisession | cut -f 2 -d' '`
			if [ x"root" != x"$uiusername" ]; then
				launchctl bsexec $uipid sudo -u $uiusername launchctl unload /Library/LaunchAgents/com.logmein.hamachimb.plist
				sudo -u $uiusername launchctl unload /Library/LaunchAgents/com.logmein.hamachimb.plist
			fi
		done
		IFS=$SaveIFS
#		;;
# esac
sleep 2
echo "Stopping Engine"
launchctl unload /Library/LaunchDaemons/com.logmein.hamachi.plist
/Applications/LogMeIn\ Hamachi/LogMeIn\ Hamachi.app/Contents/Resources/hamachidaemonctl stop
echo "Stopping user Hamachi apps"
case $pv in
	10.4.*)
		;;
	10.5.*)
		;;
	*)
		for uiusername in `ps axo "user pid command" | grep loginwindow | cut -s -d' ' -f 1`
		do
			echo $uiusername
			sudo -u $uiusername killall LogMeIn\ Hamachi.app
		done
		;;
esac
echo "Stopping root Hamachi apps (if exists)"
killall LogMeIn\ Hamachi

echo "Unloading kext"
kextunload /Library/Extensions/ham.kext
kextunload /Library/Extensions/ham.kext

echo "End preflight"

exit 0
