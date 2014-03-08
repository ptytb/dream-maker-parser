lexer grammar byond2PreprocLexer;
import byond2Common;

////////////////////////////////////////////////////////////////////////////////
// white

ML_COMMENT
    :   '/*' (ML_COMMENT | .)*? '*/' -> skip
    ;

SL_COMMENT
    :   '//' ~('\r' | '\n')* -> skip
    ;

LINE_ESCAPE
    :   '\\' ('\r'? '\n' | '\r') WS? -> skip
    ;

////////////////////////////////////////////////////////////////////////////////
// plain mode

MACRO : '#' { pushMode(Macro); skip(); } ;

ID
    :   LETTER (LETTER | DIGIT)*
    ;

ANY 
    :   .
    ;

////////////////////////////////////////////////////////////////////////////////
// macro mode

mode Macro;

MACRO_LINE_ESCAPE
    :   LINE_ESCAPE -> type(LINE_ESCAPE), skip
    ;

NL
    :   ( '\r'? '\n' | '\r')
        { popMode(); }
    ;

WS
    :   [ \t]+ -> skip
    ;

MACRO_DEFINE : 'define' ;

MACRO_UNDEF : 'undef' ;

MACRO_INCLUDE : 'include' ;

MACRO_IFDEF : 'ifdef' ;

MACRO_IF : 'if' ;

MACRO_ELIF : 'elif'   ;

MACRO_ELSE : 'else'   ;

MACRO_ENDIF : 'endif' ;

MACRO_ERROR : 'error' ;

MACRO_DEFINED : 'defined' ;

MACRO_STD_FILE : '__FILE__' ;

MACRO_STD_LINE : '__LINE__' ;

MACRO_STD_FILE_DIR : 'FILE_DIR' ;

MACRO_STD_DEBUG : 'DEBUG' ;

MACRO_STD_DM_VERSION : 'DM_VERSION' ;


PLUS : '+' ;
MINUS : '-' ;
MUL : '*' ;
SLASH : '/' ;
MOD : '%' ;
BITOR : '|' ;
BITAND : '&' ;
BITSHR : '>>' ;
BITSHL : '<<' ;
BITXOR : '^' ;
BITNOT : '~' ;
AND : '&&' ;
OR : '||' ;
NOT : '!' ;

EQ : '=' ;
LT : '<' ;
LTEQ : '<=' ;
GT : '>' ;
GTEQ : '>=' ;
CMP : '==' ;
NOTEQ : '!=' | '<>' ;

LPAREN : '(' ;
RPAREN : ')' ;

INT
    :   DIGIT+
    |   INT_HEX
    ;

COMMA : ',' ;

MACRO_ID
    :   ID -> type(ID)
    ;

QUOTE
    :   '"' ~('"')* '"'
    ;

MACRO_ANY
    :   ANY -> type(ANY)
    ;

fragment LETTER : [a-zA-Z] | '_' ;

fragment INT_HEX
    :   '0'
        ('x' | 'X')
        HEX_DIGIT+
    ;

fragment HEX_DIGIT
    :   DIGIT
    |   [a-fA-F]
    ;

fragment DIGIT:  '0'..'9' ; 

