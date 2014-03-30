lexer grammar byond2Lexer;
import byond2Common;

////////////////////////////////////////////////////////////////////////////////
// token flow control

@lexer::members
{
    private int nesting = 0;
    private int indentLevel = 0;
    private int indentUnit = 0;
    private int prevTokenType = EOF;
    private String fileName = null;
    private int macroStartCharPositionInLine;

    @Override
    public String getSourceName()
    {
        return (fileName != null)
            ? fileName
            : IntStream.UNKNOWN_SOURCE_NAME;
    }

    // Support multiple tokens add
    private final java.util.ArrayDeque<Token> pendingTokens =
        new java.util.ArrayDeque<>();
        
    // Simple token look-ahead, required for DIV token recognition
    private final java.util.ArrayDeque<Token> aheadTokens =
        new java.util.ArrayDeque<>();

    private void indent(int n)
    {
        indentLevel += n;
        while (n > 0)
        {
            addToken(INDENT, "INDENT");
            --n;
        }
    }
    
    private void dedent(int n)
    {
        indentLevel -= n;
        while (n > 0)
        {
            addToken(DEDENT, "DEDENT");
            addToken(IGNORE_NEWLINE, "NL");
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
    
        if (indentLevel == 0)
        {
            indentUnit = indent;
            indent = 1;
        }
        else
        {
            if (indent % indentUnit != 0)
            {
                throw new RuntimeException("Invalid indent, line " + getLine());
            }
            indent /= indentUnit;
        }

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

    private void addToken(int type, String text)
    {
        pendingTokens.add(_factory.create(
            _tokenFactorySourcePair,
            type,
            text,
            Token.DEFAULT_CHANNEL,
            _tokenStartCharIndex,
            _tokenStartCharIndex,
            _tokenStartLine,
            _tokenStartCharPositionInLine));
    }

    private void parseMacroLine(String macro)
    {
        int start = macro.indexOf("#");
        if (start < 0)
        {
            return;
        }

        int numEnd = macro.indexOf(" ", start + 2);
        if (numEnd < 0)
        {
            numEnd = macro.length();
        }

        int line = Integer.parseInt(macro.substring(start + 2, numEnd));

        String name = null;
        if (numEnd != macro.length())
        {
            name = macro.substring(numEnd + 1, macro.length());
        }

        setLine(line);
        fileName = name;
        macroStartCharPositionInLine = _tokenStartCharPositionInLine;
    }

    @Override
    public Token nextToken()
    {
        while (pendingTokens.isEmpty())
        {
            Token token;

            if (!aheadTokens.isEmpty())
            {
                token = aheadTokens.poll();
            }
            else
            {
                token = super.nextToken();
            }

            int type = token.getType();
            
            int tokenLinePosition = (prevTokenType == MACRO_LINE)
                ? macroStartCharPositionInLine
                : token.getCharPositionInLine();

            if (tokenLinePosition == 0
                && type != EMPTY_LINE
                && type != LEADING_WS
                && type != MACRO_LINE
                && nesting == 0)
            {
                dedentAll();
            }

            switch (type)
            {
                case LBRACK: nesting++; break;
                case RBRACK: nesting--; break; 
                case LPAREN: nesting++; break;
                case RPAREN: nesting--; break;
            }

            switch (type)
            {
                case WS:
                    if (prevTokenType == SLASH
                        || ahead().getType() == SLASH)
                    {
                        pendingTokens.add(token);
                    }
                    break;

                case EMPTY_LINE:
                case MACRO_LINE:
                    String macro = getText().trim();
                    parseMacroLine(macro);
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
// macro

MACRO_LINE
    :   '# ' INT (' ' STRING)? ' '
    ;

////////////////////////////////////////////////////////////////////////////////
// white

EMPTY_LINE
    :   { getCharPositionInLine() == 0 }?
        WS? (MACRO_LINE WS?)* NL
    ;

fragment NL
    :   '\r'? '\n' | '\r'
    ;

LEADING_WS
    :   { getCharPositionInLine() == 0 }?
        [ \t]+
        {
            if (nesting == 0)        // Not inside ( ) [ ]
            {
                emitIndent();
            }
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
            {
                skip();
            }
        }
    ;

LPAREN    : '(' ;

RPAREN    : ')' ;

LBRACK    : '[' ;

RBRACK    : ']' ;

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

COLOR : 'color' ;

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

fragment CODE_ESC : '\\' .;

ID : LETTER (LETTER | DIGIT)* ;

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
