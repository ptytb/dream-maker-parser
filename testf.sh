#!/bin/sh

cat "/media/usb3/Baystation12/Baystation12/code/__HELPERS/type2type.dm" |\
gcc -E -Wp,-w  - | \
java -cp .:/media/usb3/media/download/antlr-4.1-complete.jar Main 

#cat "/media/usb3/Baystation12/Baystation12/code/datums/mind.dm" |\
#java -cp .:/media/usb3/media/download/antlr-4.1-complete.jar Main 
