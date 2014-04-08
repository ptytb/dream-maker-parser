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
"world.dme" > amalgamation.dm
```

####Options
* **-t** show GUI parse tree;
* **-d** do not preprocess;
* **-p** preprocess only;
* **-Ipath** include search path.

###Handle parser's events
Extend *DMParserBaseListener* class or implement *DMParserListener* interface.
Then add listener to *Main.java*:
```java
parser.addParseListener(new MyParserListener());
```

###Development status
Currently parses everything from [Baystation
12](https://github.com/Baystation12/Baystation12), tested on commit
*57703df2f9f514e72fb46896d0b49262c0e63005*. Some *dm* files with quirks and
stray charachters must be fixed.

Despite this grammar is SLL, parsing code tree as a single amalgamation or
*world.dme* file with includes, consumes a lot of memory or slows down cause of
garbage collection. But it's very fast if you have enough RAM: 5 min 11 sec,
580M used for whole Baystation 12. Maybe some rework should be done here.
[ANTLR4 techreport](http://antlr.org/papers/allstar-techreport.pdf) describes
what are DFA and ATN structures who consumes your RAM.

Preprocessor currently implements directives:
* #include.

###TODO
- implement all remaining preprocessor directives;
- add parser mode for strings.

###Other implementations and related projects
- [Flex and bison dream maker
  grammars](https://github.com/nan0desu/dreamcatcher)
- [Byond port to C++ with modified dreamcatcher
  grammars](https://github.com/N3X15/OpenBYOND)
- [Vim syntax for dream maker sources](https://github.com/wlue/vim-dm-syntax)
