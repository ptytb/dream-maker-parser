parser grammar byond2Parser;

options
{
    tokenVocab = byond2Lexer;
}


////////////////////////////////////////////////////////////////////////////////
// parser

newline
    :   IGNORE_NEWLINE
    ;

label
    :   ID COLON?
        newline? block?
    ;

constant
    :   STRING
    |   (PLUS | MINUS)? (INT | FLOAT)
    |   NULL
    ;

file
    :   blockInner
        EOF
    ;

blockInner
    :   
    (   line
    |   block)

    (   newline line
    |   newline block)*

        newline?
    ;

blockBraced
    :   LCURV line?  RCURV
    |   LCURV line? newline INDENT? blockInner newline?
        (RCURV newline DEDENT? | DEDENT? RCURV)
    ;

blockIndented
    :   INDENT blockInner newline? DEDENT
    ;

block
    :   blockBraced
    |   blockIndented
    ;

line
    :   statement (SEMI statement?)*
    ;

blockInnerSwitch
    :   ifConst (newline ifConst)*
    (   newline? ELSE (newline? blockProc | statementProc)? )?
    ;

blockBracedSwitch
    :   LCURV
        blockInnerSwitch?
        RCURV
    ;

blockIndentedSwitch
    :   INDENT blockInnerSwitch newline? DEDENT
    ;

blockSwitch
    :   blockBracedSwitch
    |   blockIndentedSwitch
    ;

blockInnerProc
    :   
    (   lineProc
    |   blockProc)

    (   newline lineProc
    |   newline blockProc)*
    ;

blockBracedProc
    :   LCURV lineProc?  RCURV
    |   LCURV lineProc? newline INDENT? blockInnerProc newline?
        (RCURV newline DEDENT? | DEDENT? RCURV)
    ;

blockIndentedProc
    :   INDENT blockInnerProc newline?  DEDENT
    ;

blockProc
    :   blockBracedProc
    |   blockIndentedProc
    ;

lineProc
    :   statementProc (SEMI statementProc?)*
    ;

set
    :   SET ID (IN | EQ) expr
    ;

type
    :   TEXT | MESSAGE | NUM | ICON | SOUND | FILE | KEY | NULL 
    |   MOB | OBJ | TURF | AREA | ANYTHING | COLOR
    ;

name
    :   CALL | PICK | VAR | PROC | NEW | LIST | STEP | type | ID
    ;

pathElem
    :   name | POINT+
    ;

opDeref
    :   name ((POINT | COLON) name)+
    ;

pathExpr
    :   internalVar 
    |   WS? (SLASH | COLON | POINT) pathElem (SLASH pathElem)* SLASH? WS?
    ;

path
    :   WS?
    (   internalVar
    |   (SLASH | COLON | POINT)? pathElem (SLASH pathElem)* SLASH? WS?
    |   (SLASH | COLON | POINT) WS?
    ) 
    ;

statVarDef
    :   path listDef? (EQ expr)? (AS type)?
    ;

statVarDefList
    :   statVarDef (COMMA statVarDef)*
    ;

statVar
    :   VAR 
    (   statVarDefList
    |   path? newline? block)
    ;

listDef
    :   (LBRACK expr? RBRACK)+
    ;

procDef
    :   LPAREN
        (   formalParameters
        |   POINT POINT POINT)?
        RPAREN
        (newline? blockProc | statementProc)? // Is decl if omited
    ;

formalParameters
    :   COMMA* formalParameter (COMMA formalParameter)* COMMA*
    ; 

formalParameter
    :   path listDef? (EQ expr)? (AS type (BITOR type)*)? (IN expr)?  
    ;

procCall
    :   callable LPAREN actualParameters? RPAREN
    (   (IN expr)? (AS type (BITOR type)*)?
    |   (AS type (BITOR type)*)? (IN expr)? )
    ;

loopFor
    :   FOR
        LPAREN
        (   (statVarDef | expr) (AS type (BITOR type)*)? (IN expr)? (TO expr)?
            (STEP expr)?
        |   (statementProc | blockBracedProc)?
            (SEMI | COMMA)
            (expr | LCURV SEMI* expr? SEMI* RCURV)?
            (
            (SEMI | COMMA)
            (statementProc | blockBracedProc)?
            )?
        )?
        RPAREN
        newline? (blockProc | statementProc)
    ;

callable
    :   superRef
    |   varDefaultRet
    |   name
    |   opDeref
    ;

loopWhile
    :   WHILE
        LPAREN expr RPAREN
        newline? (blockProc | statementProc)
    ;

loopDo
    :   DO
        newline? (blockProc | statementProc)
        newline?
        WHILE LPAREN expr RPAREN
    ;

statGoto
    :   GOTO ID
    ;

ifConst
    :   IF
        LPAREN
        (   expr (COMMA expr)* COMMA?
        |   expr (OR expr)*
        |   expr TO expr)
        RPAREN
    (   newline? blockProc | statementProc)?
    ;

ifCond
    :   IF LPAREN expr RPAREN
    (   newline? blockProc | statementProc)?
        newline?
    (   ELSE (newline? blockProc | statementProc)? )?
    ;

statRet
    :   RETURN expr?
    ;

statBreak
    :   BREAK ID?
    ;

statCont
    :   CONTINUE ID?
    ;

statSpawn
    :   SPAWN
        (LPAREN expr? RPAREN)?
        newline? (blockProc | statementProc)
    ;

statDel
    :   DEL expr
    ;

statSwitch
    :   SWITCH LPAREN expr RPAREN newline? blockSwitch
    ;

statCall
    :   CALL 
        LPAREN
        (expr (COMMA expr?)?)?
        RPAREN
        LPAREN
        actualParameters?
        RPAREN
    ;

statPick
    :   PICK 
        LPAREN
        (expr (SEMI* expr SEMI*)? COMMA?)* 
        RPAREN
    ;

statInternal
    :   statCall
    |   statPick
    ;

opNew
    :   NEW 
        (path | opDeref)?
        (LPAREN actualParameters? RPAREN)?
    ;

opAssign
    :   expr EQ <assoc=right> expr
    ;

opOpAssign
    :   expr
    (   EQPLUS <assoc=right>
    |   EQMINUS <assoc=right>
    |   EQMUL <assoc=right>
    |   EQSLASH <assoc=right>
    |   EQMOD <assoc=right>
    |   EQBITOR <assoc=right>
    |   EQBITAND <assoc=right>
    |   EQBITRSH <assoc=right>
    |   EQBITLSH <assoc=right>
    |   EQBITXOR <assoc=right> )
        expr
    ;

statement
    :   path (procDef | newline? block)?
    |   opAssign
    ;

statementProc
    :   label
    |   statVar
    |   statInternal
    |   set
    |   statDel
    |   loopFor
    |   loopDo
    |   loopWhile
    |   ifCond
    |   statSwitch
    |   statRet
    |   statBreak
    |   statCont
    |   statGoto
    |   statSpawn
    |   procCall
    |   opAssign
    |   opOpAssign
    |   opNew
    |   expr BITSHR expr
    |   expr BITSHL expr
    |   (INC | DEC) expr
    |   expr (INC | DEC)        
    |   expr QMARK expr COLON expr
    ;

expr
    :   LPAREN expr RPAREN
    |   expr LBRACK expr? RBRACK
    |   (PLUS | MINUS) expr
    |   NOT expr
    |   BITNOT expr
    |   (INC | DEC) expr
    |   expr (INC | DEC)
    |   expr POW <assoc=right> expr
    |   expr (WS? SLASH WS? | MUL | MOD) expr
    |   expr (PLUS | MINUS) expr
    |   expr (LT | LTEQ | GT | GTEQ ) expr
    |   expr (BITSHL | BITSHR) expr
    |   expr (CMP | NOTEQ) expr
    |   expr (BITAND) expr
    |   expr (BITXOR) expr
    |   expr (BITOR) expr
    |   expr (AND) expr
    |   expr (OR) expr
    |   expr QMARK expr COLON expr
    |   opNew
    |   statInternal
    |   expr IN expr (TO expr)?
    |   procCall
    |   opDeref
    |   pathExpr
    |   constant
    |   name
    ; 

exprList
    :   expr (COMMA expr)*
    ; 

actualParameters
    :   (actualParameter | COMMA actualParameter?)
        (COMMA actualParameter | COMMA)*
    ; 
    
actualParameter
    :   (expr | path) (EQ expr)?
    ;

internalVar
    :   varDefaultRet
    |   superRef
    |   NULL
    ;

varDefaultRet
    :   POINT 
    ;

superRef
    :   POINT POINT
    ;

