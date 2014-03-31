#DreamMaker programming language parser.
[Byond](http://www.byond.com) is the game engine using DreamMaker as native
programming language.

##Requirements
- [ANTLR 4.2.1](http://www.antlr.org/download/antlr-4.2.1-complete.jar);
- JDK 8.

##Building
Run *make*

##Running
Run *java -Xmx2G -cp .:antlr-4.2.1-complete.jar Main -I"path/to/code"
"main.dme"*

###Options
* **-t** show GUI parse tree;
* **-d** do not preprocess;
* **-p** preprocess only;
* **-Ipath** include search path.

##Development status
Currently parses almost everything from [Baystation
12](https://github.com/Baystation12/Baystation12). 

##TODO
- complete preprocessor;
- **var** cannot be path ending.
