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
    
    private Vector<String> paths = new Vector<String>();

    private byond2ErrorListener.FileNameBinding fileNameBinding =
        new byond2ErrorListener.FileNameBinding();
    private Stack<String> fileNames = new Stack<String>();

    private BaseErrorListener errorListener = new byond2ErrorListener(
            fileNameBinding);

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
        }
        catch (IOException e) { }
    }

    // Each lexer store state for every included file
    private byond2PreprocLexer lexerFactory()
    {
        byond2PreprocLexer lexer = new byond2PreprocLexer(
                new UnbufferedCharStream(is));
        lexer.setTokenFactory(new CommonTokenFactory(true));
        lexer.removeErrorListeners();
        lexer.addErrorListener(errorListener);
        return lexer;
    }

    public void addSearchPath(String path)
    {
        paths.add(path);
    }

    private String ext(String name)
    {
        return name.substring(name.lastIndexOf('.') + 1);
    }

    private String search(String name)
    {
        for (String p : paths)
        {
            File f = new File(p, name);
            if (ext(name).equals("dm") && f.exists())
                return f.getPath();
        }
        return name;
    }

    private void include(String name)
    {
        try
        {
            String longName = search(name);
            is.include(longName); // In this context current file can be vacuumed
            lexers.push(lexer);
            lexer = lexerFactory();
            fileNames.push(fileNameBinding.fileName);
            fileNameBinding.fileName = longName;
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
        parser.removeErrorListeners();
        parser.addErrorListener(errorListener);
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

        switch (type)
        {
            //case byond2PreprocLexer.ID:
            //token = new CommonToken(token.getType(),
            //"[:ID[" + token.getText() + "]:]");

            case Token.EOF:
                if (!macro.isEmpty())
                    flushMacro();

                if (!lexers.empty())
                {
                    lexer = lexers.pop();
                    fileNameBinding.fileName = fileNames.pop();
                    return true;
                }
                break;

            default:
                if (lexer._mode == lexer.Macro)
                    macro.add(token);
                else
                {
                    if (!macro.isEmpty()) // type=NL might be catched
                        flushMacro();
                    else
                        pipe.write(token.getText());
                }
        }

        return type != Token.EOF;
    }
}
