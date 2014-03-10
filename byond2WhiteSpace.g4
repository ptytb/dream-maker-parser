lexer grammar byond2WhiteSpace;

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


