#!/bin/bash

/usr/local/munki/managedsoftwareupdate --auto
/bin/rm /Library/LaunchDaemons/org.munki.auto_run.plist
/bin/rm /usr/local/munki/auto_run.sh

exit 0