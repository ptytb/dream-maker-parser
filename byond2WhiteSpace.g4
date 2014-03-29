lexer grammar byond2WhiteSpace;

@lexer::members
{
    private int joinedLines = 0;
}

////////////////////////////////////////////////////////////////////////////////
// white

ML_COMMENT
    :   ({ getCharPositionInLine() == 0 }? WS)?
        '/*' (ML_COMMENT | .)*? '*/'
        {
            setText(String.format("# %d ", getLine()));
        }
    ;

SL_COMMENT
    :   '//' .*? (('\r'? '\n' | '\r') | EOF)
        {
            setText("\n");
        }
    ;

LINE_ESCAPE
    :   '\\' ('\r'? '\n' | '\r') WS?
        {
            ++joinedLines;
            skip();
        }
    ;


