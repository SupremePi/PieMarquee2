#!/bin/bash
#get script path

scriptfile=$(readlink -f $0)
installpath=`dirname $scriptfile`

echo -e "$(tput setaf 2)Installing Needed Updates! $(tput sgr0)"
sleep 3
sudo apt-get update
sudo apt-get install omxplayer libjpeg8 imagemagick -y
echo -e "$(tput setaf 2)Done! $(tput sgr0)"
sleep 3
clear

echo -e "$(tput setaf 2)Moving Marquee Files To Correct Locations! $(tput sgr0)"
sleep 3
cd $installpath
sudo rm -rf /opt/retropie/configs/all/PieMarquee2/
mkdir /opt/retropie/configs/all/PieMarquee2/
cp -f -r $installpath/PieMarquee2 /opt/retropie/configs/all/

#Supreme Edit
cp $HOME/PieMarquee2/scripts/supreme-marquee-tool.sh /home/pi/RetroPie/retropiemenu/
cp $HOME/PieMarquee2/scripts/supreme-marquee-tool.png /home/pi/RetroPie/retropiemenu/icons/
sudo cp -f $HOME/PieMarquee2/scripts/asplashscreen.sh /opt/retropie/supplementary/splashscreen/

chmod 755 /opt/retropie/configs/all/PieMarquee2/omxiv-marquee
chmod 755 /home/pi/RetroPie/retropiemenu/supreme-marquee-tool.sh
chmod 755 /home/pi/RetroPie/retropiemenu/icons/supreme-marquee-tool.png
sudo chmod 755 /opt/retropie/supplementary/splashscreen/asplashscreen.sh
echo -e "$(tput setaf 2)Done! $(tput sgr0)"
sleep 3
clear


echo -e "$(tput setaf 2)Making Changes to your Outo Start! $(tput sgr0)"
sleep 3

#Do Auto Start Edits#
ifexist=`cat /opt/retropie/configs/all/autostart.sh |grep isdual |wc -l`

if [[ ${ifexist} > 0 ]]; then
  echo -e "$(tput setaf 2)Marquee Script Already Found But Will Now Enable! $(tput sgr0)"
  echo "already in gamelist.xml" > /tmp/exists
  sed -i '/#isdual=`tvservice -l |grep "2 attached device" |wc -l`/c\isdual=`tvservice -l |grep "2 attached device" |wc -l`' /opt/retropie/configs/all/autostart.sh
else
cp /opt/retropie/configs/all/autostart.sh /opt/retropie/configs/all/autostart.sh.bkp
cat <<\EOF123 > "/tmp/templist"
isdual=`tvservice -l |grep "2 attached device" |wc -l`
if [[ $isdual == "1" ]]; then
fbset -fb /dev/fb0 -g 1920 1080 1920 1080 16
/usr/bin/python /opt/retropie/configs/all/PieMarquee2/PieMarquee2.py &
fi
EOF123
sed -i -f - /opt/retropie/configs/all/autostart.sh < <(sed 's/^/1i/' /tmp/templist)
fi

echo -e "$(tput setaf 2)Done! $(tput sgr0)"
sleep 3
clear

echo -e "$(tput setaf 2)Now Adding The Supreme Marquee Tool To Your Gamelist! $(tput sgr0)"
sleep 3

#Do Gamelist Edits#
cp /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml.bkp
cp /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml /tmp

cat /tmp/gamelist.xml |grep -v "</gameList>" > /tmp/templist.xml

ifexist=`cat /tmp/templist.xml |grep supreme-marquee-tool |wc -l`

if [[ ${ifexist} > 0 ]]; then
  echo -e "$(tput setaf 2)Looks Like The Supreme Marquee Tool Is Already in Your gamlist.xml So Skipping! $(tput sgr0)"
  echo "already in gamelist.xml" > /tmp/exists
else
  echo "  <game>" >> /tmp/templist.xml
  echo "    <path>./supreme-marquee-tool.sh</path>" >> /tmp/templist.xml
  echo "    <name>Supreme Marquee Tool</name>" >> /tmp/templist.xml
  echo "    <desc>The supreme marquee tool is a all in one place to set up your marquee.</desc>" >> /tmp/templist.xml
  echo "    <image>/home/pi/RetroPie/retropiemenu/icons/supreme-marquee-tool.png</image>" >> /tmp/templist.xml
  echo "    <playcount>1</playcount>" >> /tmp/templist.xml
  echo "    <lastplayed></lastplayed>" >> /tmp/templist.xml
  echo "  </game>" >> /tmp/templist.xml
  echo "</gameList>" >> /tmp/templist.xml

  cp /tmp/templist.xml /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
  cp /tmp/templist.xml /home/pi/RetroPie/retropiemenu/gamelist.xml
  
  echo -e "$(tput setaf 2)Supreme Marquee Tool Now Added To Your Gamlist.xml! $(tput sgr0)"
fi

echo -e "$(tput setaf 2)Done! Now Rebooting to Save Changes. $(tput sgr0)"
sleep 3
clear

sudo reboot


