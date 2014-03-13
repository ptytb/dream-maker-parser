#DreamMaker programming language parser.
[Byond](http://www.byond.com) is game engine using DreamMaker as native
programming language.

#Notes
##Building AST
Running parser requires java **-Xmx512M** command line key.

#TODO
- make separate block for **proc** definitions, with labels instead of nested
  procs;
- fix **{}** blocks;
- complete preprocessor;
- **var** cannot be path ending
