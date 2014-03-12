import org.antlr.v4.runtime.*;
import java.io.*;
import java.util.*;

class Preprocessor implements Runnable
{
    // Output text stream
    public PipedWriter pipe = new PipedWriter();

    private IncludeStream is;
    private byond2PreprocLexer lexer;
    private Stack<byond2PreprocLexer> lexers = new Stack<byond2PreprocLexer>();

    // Current macro
    private Vector<Token> macro = new Vector<Token>();

    Preprocessor(IncludeStream is) throws IOException
    {
        this.is = is;
        lexer = lexerFactory();
    }

    public void run()
    {
        try
        {
            while (consume())
                ;
            pipe.close();
        } catch (IOException e) { }
    }

    private byond2PreprocLexer lexerFactory()
    {
        byond2PreprocLexer lexer = new byond2PreprocLexer(
                new UnbufferedCharStream(is));
        lexer.setTokenFactory(new CommonTokenFactory(true));
        return lexer;
    }

    private void include(String name)
    {
        try
        {
            is.include(name); // In this context current file can be vacuumed
            lexers.push(lexer);
            lexer = lexerFactory();
        }
        catch (IOException e) { }
    }

    private void evalMacro(RuleContext tree)
    {
        MacroEval e = new MacroEval();
        String name = e.eval(tree);
        if (name != null)
        {
            include(name);
        }
    }

    private void flushMacro()
    {
        ListTokenSource macroStream = new ListTokenSource(macro);
        CommonTokenStream macroTokens = new CommonTokenStream(macroStream);
        byond2Preproc parser = new byond2Preproc(macroTokens);
        RuleContext tree = parser.macro();
        //tree.inspect(parser); // show in gui 
        //System.out.println(tree.toStringTree(parser));
        evalMacro(tree);
        macro.clear();
    }

    private boolean consume() throws IOException
    {
        Token token = lexer.nextToken();
        int type = token.getType();

        while (type == Token.EOF && !lexers.empty())
        {
            lexer = lexers.pop();
            token = lexer.nextToken();
            type = token.getType(); 
        }

        switch (type)
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
                    else
                        pipe.write(token.getText());
                    token = null;
                }
        }

        return type != Token.EOF;
    }
}
