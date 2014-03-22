parser grammar byond2Preproc;

options
{
    tokenVocab = byond2PreprocLexer;
}

macro
    :   macroDefinePar
    |   macroDefine
    |   macroUndef
    |   macroIncludeLib
    |   macroIncludeRel
    |   macroIfdef
    |   macroIfndef
    |   macroElif
    |   macroElse
    |   macroEndif
    |   macroIf
    |   macroError
    |   macroWarn
    ;

macroDefinePar
    :   MACRO_DEFINE ID LPAREN ID (COMMA ID)* RPAREN (ID | QUOTE | ~(NL))*
    ;

macroDefine
    :   MACRO_DEFINE (ID | macroStd) (ID | QUOTE | ~(NL))*
    ;

macroUndef
    :   MACRO_UNDEF ID
    ;

macroIncludeLib
    :   MACRO_INCLUDE LT ~(GT | NL)+ GT
    ;

macroIncludeRel
    :   MACRO_INCLUDE ~(NL)+ 
    ;

macroIfdef
    :   MACRO_IFDEF macroExpr
    ;

macroIfndef
    :   MACRO_IFNDEF macroExpr
    ;

macroElif
    :   MACRO_ELIF macroExpr
    ;

macroElse
    :   MACRO_ELSE
    ;

macroEndif
    :   MACRO_ENDIF
    ;

macroIf
    :   MACRO_IF macroExpr
    ;

macroError
    :   MACRO_ERROR (~NL)*
    ;

macroWarn
    :   MACRO_WARN (~NL)*
    ;

macroExpr
    :   MACRO_DEFINED (LPAREN ID RPAREN | ID)
    |   LPAREN macroExpr RPAREN
    |   (PLUS | MINUS) macroExpr
    |   NOT macroExpr
    |   BITNOT macroExpr
    |   macroExpr (SLASH | MUL | MOD) macroExpr
    |   macroExpr (PLUS | MINUS) macroExpr
    |   macroExpr (LT | LTEQ | GT | GTEQ ) macroExpr
    |   macroExpr (BITSHL | BITSHR) macroExpr
    |   macroExpr (CMP | NOTEQ) macroExpr
    |   macroExpr (BITAND) macroExpr
    |   macroExpr (BITXOR) macroExpr
    |   macroExpr (BITOR) macroExpr
    |   macroExpr (AND) macroExpr
    |   macroExpr (OR) macroExpr
    |   macroStd
    |   INT
    |   ID
    ;

macroStd
    :   MACRO_STD_FILE
    |   MACRO_STD_LINE
    |   MACRO_STD_DM_VERSION
    |   MACRO_STD_FILE_DIR
    |   MACRO_STD_DEBUG
    ;

