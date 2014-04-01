.SECONDARY:

IGNORE = \
	 Parser.java\
	 Lexer.java\
	 ParserBaseListener.java\
	 ParserListener.java\
	 Preproc.java\
	 PreprocLexer.java\
	 PreprocBaseListener.java\
	 PreprocListener.java

grammars = \
	   DMLexer.g4\
	   DMParser.g4\
	   PreprocLexer.g4\
	   Preproc.g4

classes_g4 = $(grammars:.g4=.class)

sources = $(wildcard src/*.java)
classes = $(sources:.java=.class)

all: $(classes_g4) $(classes)

%.class: src-g4/grammar/%.java 
	javac -cp src:src-g4/grammar:/media/usb3/media/download/antlr-4.2.1-complete.jar \
	    -d class $<

src/%.class: src/%.java
	javac -cp src:src-g4/grammar:/media/usb3/media/download/antlr-4.2.1-complete.jar \
	    -d class $<

src-g4/grammar/%.java: grammar/%.g4
	java -jar /media/usb3/media/download/antlr-4.2.1-complete.jar \
	    -o src-g4 -lib src-g4/grammar $?

.PHONY: test testf clean

clean:
	-rm byond2Parser.java
	-rm byond2Lexer.java
	-rm byond2ParserBaseListener.java
	-rm byond2ParserListener.java
	-rm byond2Preproc.java
	-rm byond2PreprocLexer.java
	-rm byond2PreprocBaseListener.java
	-rm byond2PreprocListener.java
	-rm byond2PreprocVisitor.java
	-rm byond2PreprocBaseVisitor.java
	-rm byond2ParserBaseVisitor.java
	-rm byond2ParserVisitor.java
	-rm byond2Common.java
	-rm class/*.class
	-rm -rf src-g4/grammar/*
	-rm byondp.jar

jar: byondp.jar

byondp.jar:
	@jar cf byondp.jar class/*.class

test:
	@./test.sh

testf:
	@./testf.sh

test_output:
	@./testf.sh output.dm


