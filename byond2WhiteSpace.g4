lexer grammar byond2WhiteSpace;

@lexer::members
{
    private int joinedLines = 0;
}

////////////////////////////////////////////////////////////////////////////////
// white

ML_COMMENT
    :   '/*' (ML_COMMENT | .)*? '*/'
        {
            setText(String.format("\n#line %d\n", getLine()));
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


