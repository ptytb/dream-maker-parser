###Dream Maker programming language parser
[Byond](http://www.byond.com) is the game engine using Dream Maker as native
programming language. [Dream Maker language 
guide](http://www.byond.com/docs/guide/guide.pdf). The goal of this project is
complete standalone preprocessor and parser for DM language, written in ANTLR4
and Java.

###Requirements
- [ANTLR 4.2.1](http://www.antlr.org/download/antlr-4.2.1-complete.jar);
- JDK 8.

###Building
Run *make*

###Running
Run *java -Xmx2G -cp .:antlr-4.2.1-complete.jar Main -I"path/to/code"
"main.dme"* 

####Options
* **-t** show GUI parse tree;
* **-d** do not preprocess;
* **-p** preprocess only;
* **-Ipath** include search path.

###Development status
Currently parses everything from [Baystation
12](https://github.com/Baystation12/Baystation12). Some dm files with quirks and
 stray charachters must be fixed.

Parsing code tree as single *world.dme* file with includes, consumes a lot of
memory and slows down, despite SLL grammar. Need some rework here.

Preprocessor currently implements directives:
* #include.

###TODO
- implement all remaining preprocessor directives;
- add parser mode for strings.
