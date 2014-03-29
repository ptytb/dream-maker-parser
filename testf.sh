#!/bin/sh

#cat "/media/usb3/byond-port/test.pre" |\

#java -Xmx512M -cp .:/media/usb3/media/download/antlr-4.2-complete.jar Main $1

java -Xmx768M -cp .:/media/usb3/media/download/antlr-4.2-complete.jar Main \
"/media/usb3/Baystation12/Baystation12/baystation12.dme"
#"/media/usb3/Baystation12/Baystation12/code/game/objects/items/weapons/kitchen.dm"
#"/media/usb3/byond-port/test.dm"
