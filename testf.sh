#!/bin/sh

cat "/media/usb3/Baystation12/Baystation12/code/ZAS/FEA_gas_mixture.dm" |\
#gcc -E -Wp,-w  - | \
gpp -C | \
java -Xmx512M -cp .:/media/usb3/media/download/antlr-4.1-complete.jar Main 

#cat "/media/usb3/Baystation12/Baystation12/code/datums/mind.dm" |\
#java -cp .:/media/usb3/media/download/antlr-4.1-complete.jar Main 
