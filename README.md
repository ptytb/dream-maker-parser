#DreamMaker programming language parser.
[Byond](http://www.byond.com) is the game engine using DreamMaker as native
programming language.

##Requirements
- ANTLR 4.2;
- JDK 8.

##Development status
Currently parses almost everything from [Baystation 13](). 

##Building AST
Running parser requires java **-Xmx512M** command line key.

#TODO
- complete preprocessor;
- **var** cannot be path ending.
