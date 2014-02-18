
////////////////////////////////////////////////////////////////////////////////
// macro

MACRO_MODE : '#' -> pushMode(Macro);

////////////////////////////////////////////////////////////////////////////////
// macro parser

macrodef
    :   MACRO_MODE

        macro_define_par
    |   macro_define
    |   macro_undef
    |   macro_include
    |   macro_ifdef
    |   macro_elif
    |   macro_else
    |   macro_endif
    |   macro_if
    ;

macro_define_par
    :   MACRO_DEFINE_PAR
        WS
        ID
    (   LPAREN
        ID (COMMA ID)*
        RPAREN)
        macro_expr
    ;

macro_define
    :   MACRO_DEFINE
        ID
        macro_expr?
    ;

macro_undef
    :   MACRO_UNDEF
        ID
    ;

macro_include
    :   MACRO_INCLUDE
        STRING
    ;

macro_ifdef
    :   MACRO_IFDEF
        macro_expr
    ;

macro_elif
    :   MACRO_ELIF
        macro_expr
    ;

macro_else
    :   MACRO_ELSE
    ;

macro_endif
    :   MACRO_ENDIF
    ;

macro_if
    :   MACRO_IF
        macro_expr
    ;

macro_expr
    :   LPAREN macro_expr RPAREN
    |   (PLUS | MINUS) macro_expr
    |   NOT macro_expr
    |   BITNOT macro_expr
    |   (INC | DEC) macro_expr
    |   macro_expr (INC | DEC)
    |   macro_expr (MUL | DIV | MOD) macro_expr
    |   macro_expr POW <assoc=right> macro_expr
    |   macro_expr (PLUS | MINUS) macro_expr
    |   macro_expr (LT | LTEQ | GT | GTEQ ) macro_expr
    |   macro_expr (CMP | NOTEQ) macro_expr
    |   macro_expr (BITSHL | BITSHR) macro_expr
    |   macro_expr (BITAND | BITOR | BITXOR) macro_expr
    |   macro_expr (AND) macro_expr
    |   macro_expr (OR) macro_expr
    |   INT
    |   FLOAT
    |   ID
    ;


////////////////////////////////////////////////////////////////////////////////
// ``macro'' mode

mode Macro;

MACRO_NL
    :   '\r' ? '\n' -> popMode
    ;

MACRO_WS
    :   [ \t]+
    ;

MACRO_ID
    :   ID -> type(ID)
    ;

MACRO_PLUS 
    :   PLUS -> type(PLUS)
    ;

MACRO_LPAREN
    :   LPAREN -> type(LPAREN)
    ;

MACRO_RPAREN
    :   RPAREN -> type(RPAREN)
    ;

MACRO_COMMA
    :   COMMA -> type(COMMA)
    ;


MACRO_DEFINE_PAR : 'define'
    {
        _input.LA(1) == WS &&
        _input.LA(2) == ID &&
        _input.LA(3) == LBRACK
    }?
    ;

MACRO_DEFINE : 'define' ;

MACRO_UNDEF : 'undef' ;

MACRO_INCLUDE : 'include' ;

MACRO_IFDEF : 'ifdef' ;

MACRO_IF : 'if'  ;

MACRO_ELIF : 'elif'   ;

MACRO_ELSE : 'else'   ;

MACRO_ENDIF : 'endif'   ;

////////////////////////////////////////////////////////////////////////////////
