#!/bin/sh


exec 2>errors.txt

find /media/usb3/Baystation12/Baystation12/code \
    -name '*.dm' -type f -print | while read fname; do echo $fname 1>&2; \
    java -Xmx512M -cp .:/media/usb3/media/download/\
antlr-4.2.1-complete.jar Main "$fname"  > /dev/null ; done
