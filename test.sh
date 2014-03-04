#!/bin/sh


exec 2>errors.txt

find /media/usb3/Baystation12/Baystation12/code \
    -name '*.dm' -type f -print | while read fname; do echo $fname 1>&2; \
    cat "$fname" | \
    #gcc -E -Wp,-w - | \
    gpp -C | \
    java -Xmx512M -cp .:/media/usb3/media/download/\
antlr-4.1-complete.jar Main  > /dev/null ; done
