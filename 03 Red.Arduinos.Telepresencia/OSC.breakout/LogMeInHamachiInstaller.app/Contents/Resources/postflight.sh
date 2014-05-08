#!/bin/sh

# stop hamachid if preflight.sh was not successfull
/Applications/LogMeIn\ Hamachi/LogMeIn\ Hamachi.app/Contents/Resources/hamachidaemonctl stop
killall LogMeIn\ Hamachi

sleep 2

[ -d /etc/resolver ] || mkdir -p -m 755 /etc/resolver

# create link
/bin/ln -sf "/Library/Application Support/LogMeIn Hamachi/bin/hamachid" /usr/bin/hamachi

# need to remove write from group
/bin/chmod go-w "/Library/LaunchDaemons/com.logmein.hamachi.plist"
/bin/chmod go-w "/Library/LaunchAgents/com.logmein.hamachimb.plist"
/bin/chmod -R go-w "/Library/Extensions/ham.kext"					

INSTALL_LINK="${2}/Contents/Resources/h2-install-link.cfg"
ENGINE_CFG="/Library/Application Support/LogMeIn Hamachi/config/h2-engine.cfg"

mkdir -p "/Library/Application Support/LogMeIn Hamachi/config/"
/bin/cat  "$INSTALL_LINK" >> $ENGINE_CFG
chmod 777 "/Library/Application Support/LogMeIn Hamachi/run"

pv=`/usr/bin/sw_vers -productVersion`

echo Starting Engine...
/Applications/LogMeIn\ Hamachi/LogMeIn\ Hamachi.app/Contents/Resources/hamachidaemonctl start
sleep 2
echo Engine started

echo Starting MenuBars...
case $pv in
	10.4.*)
		launchctl load -w /Library/LaunchAgents/com.logmein.hamachimb.plist
		;;
	*)
		SaveIFS=$IFS
		IFS="\n"
		for uisession in `ps axo "user pid command" | grep -v grep | grep loginwindow | tr -s ' ' | cut -f 1-2 -d' '`
		do
			uiusername=`echo $uisession | cut -f 1 -d' '`
			uipid=`echo $uisession | cut -f 2 -d' '`
			if [ x"root" != x"$uiusername" ]; then
				echo "uisession: "$uisession" -  uiusername: "$uiusername
				launchctl bsexec $uipid sudo -u $uiusername launchctl load -w /Library/LaunchAgents/com.logmein.hamachimb.plist
				sudo -u $uiusername launchctl load -w /Library/LaunchAgents/com.logmein.hamachimb.plist
			fi
		done
		IFS=$SaveIFS
		;;
esac
echo MenuBars started

exit 0
