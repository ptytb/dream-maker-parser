#!/bin/sh

all: byond2Lexer.java byond2Parser.java *.class

byond2Lexer.java byond2Parser.java:
	java -jar /media/usb3/media/download/antlr-4.1-complete.jar \
	    byond2Parser.g4 byond2Lexer.g4

*.class:
	javac -cp .:/media/usb3/media/download/antlr-4.1-complete.jar *.java

clean:
	mv main.java main.java_
	-rm *.java
	-rm *.class
	-rm *.tokens
	mv main.java_ main.java 

test:
	./test.sh

testf:
	./testf.sh

.PHONY: test testf

