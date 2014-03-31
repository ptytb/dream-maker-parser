#!/bin/sh

#cat "/media/usb3/byond-port/test.pre" |\

#java -Xmx512M -cp .:/media/usb3/media/download/antlr-4.2-complete.jar Main $1

java -Xmx768M -cp class:/media/usb3/media/download/antlr-4.2.1-complete.jar Main \
-I"/media/usb3/Baystation12/Baystation12" "baystation12.dme"
#"/media/usb3/Baystation12/Baystation12/code/world.dm"
#"/media/usb3/byond-port/test.dm"
#"/media/usb3/byond-port/test.pre"
