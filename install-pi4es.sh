#!/bin/bash

#get script path
scriptfile=$(readlink -f $0)
installpath=`dirname $scriptfile`

echo "Shutdown ES"
sudo killall /opt/retropie/supplementary/emulationstation/emulationstation
sleep 1
echo "Install PieMarquee2 integrated ES"
sudo cp -n /opt/retropie/supplementary/emulationstation/emulationstation /opt/retropie/supplementary/emulationstation/emulationstation_ori
sudo cp $installpath/scripts/ES-pi4/emulationstation /opt/retropie/supplementary/emulationstation/
sudo chmod 755 /opt/retropie/supplementary/emulationstation/emulationstation
echo
echo "Setup Completed. Reboot in 3 Seconds"
sleep 3
sudo reboot
