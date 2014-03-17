parser grammar byond2Preproc;

options
{
    tokenVocab = byond2PreprocLexer;
}

macro
    :   macro_define_par
    |   macro_define
    |   macro_undef
    |   macro_include_lib
    |   macro_include_rel
    |   macro_ifdef
    |   macro_ifndef
    |   macro_elif
    |   macro_else
    |   macro_endif
    |   macro_if
    |   macro_error
    |   macro_warn
    ;

macro_define_par
    :   MACRO_DEFINE ID LPAREN ID (COMMA ID)* RPAREN (ID | QUOTE | ~(NL))*
    ;

macro_define
    :   MACRO_DEFINE (ID | macro_std) (ID | QUOTE | ~(NL))*
    ;

macro_undef
    :   MACRO_UNDEF ID
    ;

macro_include_lib
    :   MACRO_INCLUDE LT ~(GT | NL)+ GT
    ;

macro_include_rel
    :   MACRO_INCLUDE ~(NL)+ 
    ;

macro_ifdef
    :   MACRO_IFDEF macro_expr
    ;

macro_ifndef
    :   MACRO_IFNDEF macro_expr
    ;

macro_elif
    :   MACRO_ELIF macro_expr
    ;

macro_else
    :   MACRO_ELSE
    ;

macro_endif
    :   MACRO_ENDIF
    ;

macro_if
    :   MACRO_IF macro_expr
    ;

macro_error
    :   MACRO_ERROR (~NL)*
    ;

macro_warn
    :   MACRO_WARN (~NL)*
    ;

macro_expr
    :   MACRO_DEFINED (LPAREN ID RPAREN | ID)
    |   LPAREN macro_expr RPAREN
    |   (PLUS | MINUS) macro_expr
    |   NOT macro_expr
    |   BITNOT macro_expr
    |   macro_expr (SLASH | MUL | MOD) macro_expr
    |   macro_expr (PLUS | MINUS) macro_expr
    |   macro_expr (LT | LTEQ | GT | GTEQ ) macro_expr
    |   macro_expr (BITSHL | BITSHR) macro_expr
    |   macro_expr (CMP | NOTEQ) macro_expr
    |   macro_expr (BITAND) macro_expr
    |   macro_expr (BITXOR) macro_expr
    |   macro_expr (BITOR) macro_expr
    |   macro_expr (AND) macro_expr
    |   macro_expr (OR) macro_expr
    |   macro_std
    |   INT
    |   ID
    ;

macro_std
    :   MACRO_STD_FILE
    |   MACRO_STD_LINE
    |   MACRO_STD_DM_VERSION
    |   MACRO_STD_FILE_DIR
    |   MACRO_STD_DEBUG
    ;

