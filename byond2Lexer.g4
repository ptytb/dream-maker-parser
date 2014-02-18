lexer grammar byond2Lexer;

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
        while (n > 0)
        {
            pendingTokens.add(new CommonToken(INDENT, "INDENT"));
            --n;
        }
    }
    
    private void dedent(int n)
    {
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
        indentLevel = 0;
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

        indentLevel = indent;
    }

    private Token ahead()
    {
        Token t = super.nextToken();
        aheadTokens.add(t);
        return t;
    }

    boolean isPrimitiveType(int type)
    {
        return type == INT
            || type == FLOAT
            || type == STRING;
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
                && token.getCharPositionInLine() == 0)
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

                case SLASH:
                    if (isPrimitiveType(ahead().getType()))
                    {
                        pendingTokens.add(new CommonToken(DIV, "/"));
                        break;
                    } else if (isPrimitiveType(prevTokenType))
                    {
                        pendingTokens.add(new CommonToken(DIV, "/"));
                        break;
                    } 
                    pendingTokens.add(token);
                    break;

                case COLON:
                case POINT:
                    if (ahead().getType() != ID
                        || isPrimitiveType(prevTokenType))
                    {
                        pendingTokens.add(token);
                    } else
                    {
                        if (type == COLON)
                            pendingTokens.add(new CommonToken(LOOK_DOWN, ":"));
                        else
                            pendingTokens.add(new CommonToken(LOOK_UP, "."));
                    } 
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

LEADING_WS
    :   { getCharPositionInLine() == 0 }?
        [ \t]+
        {
            if (nesting == 0)   // Not in proc's arglist ( ) [ ]
                emitIndent();
            skip();
        }
        ;

WS
    :   [ \t]+ -> skip
    ;

fragment NL
    :   '\r'? '\n'
    ;

IGNORE_NEWLINE
    :   NL
        {
            if (nesting > 0)
                skip();
        }
    ;

ML_COMMENT
    :   '/*' .* '*/' -> skip, channel(HIDDEN)
    ;

SL_COMMENT
    :   ('#' | '//') ~('\r' | '\n')* -> skip, channel(HIDDEN)
    ;

LPAREN    : '(' { nesting++; } ;

RPAREN    : ')' { nesting--; } ;

LBRACK    : '[' { nesting++; } ;

RBRACK    : ']' { nesting--; } ;

LCURV     : '{' ;

RCURV     : '}' ;

LINE_JOIN
    :   '\\' IGNORE_NEWLINE -> skip
    ;

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

NULL : 'null' ;

////////////////////////////////////////////////////////////////////////////////
// types

VAR : 'var' ;

OBJ : 'obj' ;

PROC : 'proc' ;

LIST : 'list' ;

////////////////////////////////////////////////////////////////////////////////
// internal procs

CALL :  'call';

PICK    :   'pick';

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

fragment EVAL
    :   '[' (EVAL | ~(']') )* ']'
    ;

fragment STRING_MULTILINE
    :   '{"' .*? '"}'
    ;

STRING
    :   '"' (STRING_MACRO | STRING_ESC | ~('\\'|'"') | EVAL)* '"'
    |   '\'' (STRING_MACRO | STRING_ESC | ~('\\'|'\'') | EVAL)* '\''
    |   STRING_MULTILINE
    ;

fragment STRING_MACRO
    :   '\\'
        ('the' | 'The')
    |   ('a' | 'an' | 'A' | 'An')
    |   ('he' | 'He' | 'she' | 'She')
    |   ('his' | 'His')
    |   ('hers')
    |   ('him')
    |   ('himself' | 'herself')
    |   ('th')
    |   ('s')
    |   ('proper' | 'improper')
    |   'ref' | 'icon'
    |   ('red' | 'blue' )
    |   ID
    ;

fragment STRING_ESC : '\\' (THREE_DOTS | .) ;

fragment CODE_ESC
    :   '\\' . 
        { 
            setText("" + getText().charAt(1));
        }
    ;

THREE_DOTS  :   '...'   ;

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
PATH_BEGIN : ;
PATH_END : ;
DIV :   ;
LOOK_UP : ;
LOOK_DOWN : ;


