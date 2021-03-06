parser grammar DMParser;

options
{
    tokenVocab = DMLexer;
}


////////////////////////////////////////////////////////////////////////////////
// parser

newline
    :   IGNORE_NEWLINE
    ;

label
    :   ID COLON? (newline? blockProc)?
    ;

constant
    :   STRING
    |   (PLUS | MINUS)? (INT | FLOAT)
    |   NULL
    ;

file
    :   blockInner?
        newline?
        EOF
    ;

delimiter
    :   SEMI
    |   newline
    ;

blockInner
    :   statement (delimiter statement?)*
    ;

blockBraced
    :   LCURV INDENT newline? blockInner? DEDENT newline RCURV
    ;

blockIndented
    :   INDENT blockInner newline? DEDENT
    ;

block
    :   blockBraced
    |   blockIndented
    ;

blockInnerSwitch
    :   ifConst (newline ifConst)*
    (   newline? ELSE (newline? blockProc | statementProc)? )?
    ;

blockBracedSwitch
    :   LCURV INDENT newline? blockInnerSwitch? DEDENT newline RCURV
    ;

blockIndentedSwitch
    :   INDENT blockInnerSwitch newline? DEDENT
    ;

blockSwitch
    :   blockBracedSwitch
    |   blockIndentedSwitch
    ;

blockInnerProc
    :   statementProc (delimiter statementProc?)*
    ;

blockBracedProc
    :   LCURV INDENT newline? blockInnerProc? DEDENT newline RCURV
    ;

blockIndentedProc
    :   INDENT blockInnerProc newline? DEDENT
    ;

blockProc
    :   blockBracedProc
    |   blockIndentedProc
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
    :   WS? (SLASH | COLON | POINT) pathElem (SLASH pathElem)* SLASH? WS?
    ;

path
    :   WS?
    (   (SLASH | COLON | POINT)? pathElem (SLASH pathElem)* SLASH? WS?
    |   (SLASH | COLON | POINT) WS?) 
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
    :   LPAREN actualParameters? RPAREN
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
            expr?
            (
            (SEMI | COMMA)
            (statementProc | blockBracedProc)?
            )?
        )?
        RPAREN
        newline? (blockProc | statementProc)
    ;

callable
    :   varSuper
    |   varSelf
    |   opDeref
    |   name
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
    (   newline? ELSE (newline? blockProc | statementProc)? )?
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
        (opDeref | path)?
        (LPAREN actualParameters? RPAREN)?
    ;

opAssign
    :   expr EQ expr
    ;

opOpAssign
    :   expr
    (   EQPLUS 
    |   EQMINUS 
    |   EQMUL 
    |   EQSLASH 
    |   EQMOD 
    |   EQBITOR 
    |   EQBITAND 
    |   EQBITRSH 
    |   EQBITLSH 
    |   EQBITXOR )
        expr
    ;

statement
    :   path
    (   procDef
    |   newline? block
    |   listDef? EQ expr)?
    |   statVar
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
    |   opAssign
    |   opOpAssign
    |   expr
    ;

expr
    :   LPAREN expr RPAREN
    |   expr LBRACK expr? RBRACK
    |   (PLUS | MINUS) expr
    |   NOT expr
    |   BITNOT expr
    |   (INC | DEC) expr
    |   expr (INC | DEC)
    |   expr POW expr
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
    |   expr QMARK expr WS? COLON WS? expr
    |   opNew
    |   statInternal
    |   expr IN expr (TO expr)?
    |   callable procCall?
    |   pathExpr
    |   constant
    ; 

actualParameters
    :   (actualParameter | COMMA actualParameter?) (COMMA actualParameter?)*
    ; 
    
actualParameter
    :   (expr | path) (EQ expr)?
    ;

varSelf
    :   WS? POINT WS?
    ;

varSuper
    :   WS? POINT POINT WS?
    ;

