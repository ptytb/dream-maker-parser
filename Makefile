#!/bin/sh

IGNORE = \
	 byond2Parser.java\
	 byond2Lexer.java\
	 byond2ParserBaseListener.java\
	 byond2ParserListener.java\
	 byond2Preproc.java\
	 byond2PreprocLexer.java\
	 byond2PreprocBaseListener.java\
	 byond2PreprocListener.java\
	 byond2MacroEval.java

grammars = \
	   byond2Lexer.g4\
	   byond2Parser.g4\
	   byond2PreprocLexer.g4\
	   byond2Preproc.g4

sources = $(grammars:.g4=.java)
classes = $(grammars:.g4=.class)

SRCS = $(wildcard *.java)
SRCF = $(filter-out $(IGNORE), $(SRCS))
CLS = $(SRCF:.java=.class)

all: $(classes) $(CLS)

%.class: %.java
	javac -cp .:/media/usb3/media/download/antlr-4.2-complete.jar $<

%.java: %.g4
ifeq ('byond2Preproc.g4',$?)
	java -jar /media/usb3/media/download/antlr-4.2-complete.jar -visitor $?
else
	java -jar /media/usb3/media/download/antlr-4.2-complete.jar $?
endif

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
	-rm *.class
	-rm *.tokens

test:
	@./test.sh

testf:
	@./testf.sh

test_output:
	@./testf.sh output.dm

.PHONY: test testf all
.SECONDARY:

