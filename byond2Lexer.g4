lexer grammar byond2Lexer;
import byond2Common;

////////////////////////////////////////////////////////////////////////////////
// token flow control

@lexer::members
{
    private int nesting = 0;
    private int indentLevel = 0;
    private int prevTokenType = EOF;
    
    // Support multiple tokens add
    private final java.util.Deque<Token> pendingTokens =
        new java.util.ArrayDeque<>();
        
    // Simple token look-ahead, required for DIV token recognition
    private final java.util.Deque<Token> aheadTokens =
        new java.util.ArrayDeque<>();

    private void indent(int n)
    {
        indentLevel += n;
        while (n > 0)
        {
            pendingTokens.add(new CommonToken(INDENT, "INDENT"));
            --n;
        }
    }
    
    private void dedent(int n)
    {
        indentLevel -= n;
        while (n > 0)
        {
            pendingTokens.add(new CommonToken(DEDENT, "DEDENT"));
            pendingTokens.add(new CommonToken(IGNORE_NEWLINE, "NL"));
            --n;
        }
    }
    
    private void dedentAll()
    {
        dedent(indentLevel);
    }

    private void emitIndent()
    {
        int indent = getText().length();

        if (indent > indentLevel)
        {
            indent(indent - indentLevel);
        }
        else if (indent < indentLevel)
        {
            dedent(indentLevel - indent);
        }
    }

    private Token ahead()
    {
        Token t = super.nextToken();
        aheadTokens.add(t);
        return t;
    }

    @Override
    public Token nextToken()
    {
        while (pendingTokens.isEmpty())
        {
            Token token = null;

            if (!aheadTokens.isEmpty())
                token = aheadTokens.poll();
            else
                token = super.nextToken();

            int type = token.getType();
            
            if (type != LEADING_WS
                && type != IGNORE_NEWLINE
                && token.getCharPositionInLine() == 0
                && nesting == 0)
            {
                dedentAll();
            }

            switch (type)
            {
                case PICK:
                    if (prevTokenType == SLASH)
                        pendingTokens.add(new CommonToken(ID, token.getText()));
                    else
                        pendingTokens.add(token);
                    break;

                case WS:
                    if (prevTokenType == SLASH
                        || ahead().getType() == SLASH)
                        pendingTokens.add(token);
                    break;

                case EOF:
                    dedentAll();

                default:
                    pendingTokens.add(token);
                    break;
            }

            prevTokenType = type;
        }

        return pendingTokens.poll();
    }
}

////////////////////////////////////////////////////////////////////////////////
// white

EMPTY_LINE
    :   { getCharPositionInLine() == 0 }? WS? NL -> skip
    ;

fragment NL
    :   '\r'? '\n'
    |   '\r'
    ;

LEADING_WS
    :   { getCharPositionInLine() == 0 }?
        [ \t]+
        {
            if (nesting == 0)        // Not inside ( ) [ ]
                emitIndent();
            skip();
        }
    ;

WS
    :   [ \t]+
    ;

IGNORE_NEWLINE
    :   NL
        {
            if (nesting > 0)
                skip();
        }
    ;

LPAREN    : '(' { nesting++; } ;

RPAREN    : ')' { nesting--; } ;

LBRACK    : '[' { nesting++; } ;

RBRACK    : ']' { nesting--; } ;

LCURV     : '{' ;

RCURV     : '}' ;

////////////////////////////////////////////////////////////////////////////////
// keywords

NEW :   'new'    ;

DEL :   'del'   ;

SWITCH    :   'switch'    ;

FOR :   'for'   ;

DO  :   'do'    ;

WHILE   :   'while' ;

GOTO :  'goto';

IF    :   'if'    ;

ELSE    :   'else'    ;

RETURN  :   'return'    ;

BREAK   :   'break' ;

CONTINUE    :   'continue'  ;

SPAWN   :   'spawn' ;

SET :   'set'   ;

TO  :   'to'    ;

IN  :   'in'    ;

AS  :   'as'    ;

STEP : 'step' ;

NULL : 'null' ;

VAR : 'var' ;

PROC : 'proc' ;

////////////////////////////////////////////////////////////////////////////////
// types

TEXT : 'text' ;

MESSAGE : 'message' ;

NUM : 'num' ;

ICON : 'icon' ;

SOUND : 'sound' ;

FILE : 'file';

KEY : 'key';

MOB : 'mob' ;

OBJ : 'obj' ;

TURF : 'turf' ;

AREA : 'area' ;

ANYTHING : 'anything' ;

////////////////////////////////////////////////////////////////////////////////
// internal procs

CALL : 'call';

PICK : 'pick';

LIST : 'list' ;

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// lexem

INT
    :   DIGIT+
    |   INT_HEX
    ;

fragment INT_HEX
    :   '0'
        ('x' | 'X')
        HEX_DIGIT+
    ;

fragment HEX_DIGIT
    :   DIGIT
    |   [a-fA-F]
    ;

FLOAT
    :   DIGIT+ '.' DIGIT* EXP? 
    |   DIGIT+ EXP? 
    |   '.' DIGIT+ EXP? 
    ;

fragment DIGIT:  '0'..'9' ; 

fragment EXP :  ('E' | 'e') ('+' | '-')? INT ;

fragment LETTER : [a-zA-Z] | '_' | CODE_ESC;

ID : LETTER (LETTER | DIGIT)* ;

fragment CODE_ESC
    :   '\\' . 
        { 
            setText("" + getText().charAt(1));
        }
    ;

POINT : '.' ;

COMMA : ',' ;

COLON   :   ':'    ;

SEMI :   ';' ;

EQ : '=' ;

EQPLUS : '+=' ;
EQMINUS : '-=' ;
EQMUL : '*=' ;
EQSLASH : '/=' ;
EQMOD : '%=' ;
EQBITOR : '|=' ;
EQBITAND : '&=' ;
EQBITRSH : '>>=' ;
EQBITLSH : '<<=' ;
EQBITXOR : '^=' ;

PLUS : '+' ;
MINUS : '-' ;
MUL : '*' ;
SLASH : '/' ;
MOD : '%' ;
POW : '**' ;
BITOR : '|' ;
BITAND : '&' ;
BITSHR : '>>' ;
BITSHL : '<<' ;
BITXOR : '^' ;
BITNOT : '~' ;
AND : '&&' ;
OR : '||' ;
NOT : '!' ;
INC : '++' ;
DEC : '--' ;

LT : '<' ;
LTEQ : '<=' ;
GT : '>' ;
GTEQ : '>=' ;
CMP : '==' ;
NOTEQ : '!=' | '<>' ;

QMARK : '?' ;

INDENT : ;
DEDENT : ;
