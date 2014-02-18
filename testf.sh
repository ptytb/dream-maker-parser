#!/bin/sh

cat "/media/usb3/Baystation12/Baystation12/code/datums/disease.dm" |\
gcc -E -Wp,-w  - | \
../../prog/jdk1.7.0_51/bin/java -cp .:/media/usb3/media/download/\
antlr-4.1-complete.jar Main 
