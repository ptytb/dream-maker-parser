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
Run
```bash
make
```

###Running
Parse file:
```bash
java -Xmx2G -cp .:antlr-4.2.1-complete.jar Main [-t -d -p] -I"path/to/code" 
"main.dme"
```
Preprocess all and catenate to a single file:
```bash
java -Xmx2G -cp .:antlr-4.2.1-complete.jar Main -I"path/to/code" -p 
-I"path/to/code" "world.dme" > amalgamation.dm
```

####Options
* **-t** show GUI parse tree;
* **-d** do not preprocess;
* **-p** preprocess only;
* **-Ipath** include search path.

###Development status
Currently parses everything from [Baystation
12](https://github.com/Baystation12/Baystation12). Some *dm* files with quirks
and stray charachters must be fixed.

Despite SLL grammar, parsing code tree as a single amalgamation or *world.dme*
file with includes, consumes a lot of memory or slows down cause of garbage
collection. But it seem to be very fast if you have enough RAM. Maybe some
rework should be done here. [ANTLR4
techreport](http://antlr.org/papers/allstar-techreport.pdf) describes what are
DFA and ATN structures who consumes all your RAM.

Preprocessor currently implements directives:
* #include.

###TODO
- implement all remaining preprocessor directives;
- add parser mode for strings.
