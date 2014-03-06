import org.antlr.v4.runtime.*;
import java.io.*;
import java.util.*;

class Preprocessor implements Runnable
{
    public PipedWriter pipe = new PipedWriter();
    private byond2PreprocLexer lexer;
    private Vector<Token> macro = new Vector<Token>();
    private IncludeStream is;

    Preprocessor(IncludeStream input) throws IOException
    {
        is = input;
        lexer = new byond2PreprocLexer(new ANTLRInputStream(input));
    }

    public void run()
    {
        try
        {
            while (consumeNextToken())
                ;
            pipe.close();
        } catch (IOException e) { }
    }

    private void flushMacro()
    {
        ListTokenSource macroStream = new ListTokenSource(macro);
        CommonTokenStream macroTokens = new CommonTokenStream(macroStream);
        byond2Preproc parser = new byond2Preproc(macroTokens);
        RuleContext tree = parser.macro();
        //tree.inspect(parser); // show in gui 
        //System.out.println(tree.toStringTree(parser));
        macro.clear();
    }

    private boolean consumeNextToken() throws IOException
    {
        Token token = lexer.nextToken();

        switch (token.getType())
        {
            //case byond2PreprocLexer.ID:
            //token = new CommonToken(token.getType(),
            //"[:ID[" + token.getText() + "]:]");

            case Token.EOF:
                if (!macro.isEmpty())
                    flushMacro();
                break;

            default:
                if (lexer._mode == lexer.Macro)
                    macro.add(token);
                else
                {
                    if (!macro.isEmpty())
                        flushMacro();
                    pipe.write(token.getText());
                }
        }

        return token.getType() != Token.EOF;
    }
}
