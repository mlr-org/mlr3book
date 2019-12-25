#!/bin/sh
#Updated on 2018-06-13 for FiraSans version 4.3 and to copy both oft and ttf files
#Note: The variant of Fira Code install does not include ligatures.
#      If you want the Fira Code variant with ligatures, follow this: https://github.com/tonsky/FiraCode/wiki/Linux-instructions

wget https://github.com/bBoxType/FiraSans/archive/master.zip
unzip master.zip
sudo mkdir -p /usr/share/fonts/opentype/fira
sudo mkdir -p /usr/share/fonts/truetype/fira
sudo find FiraSans-master/ -name "*.otf" -exec cp {} /usr/share/fonts/opentype/fira/ \;
sudo find FiraSans-master/ -name "*.ttf" -exec cp {} /usr/share/fonts/truetype/fira/ \;
