import org.antlr.v4.runtime.*;
import java.io.*;
import java.util.*;

class FileState
{
    File file;
    InputStream fs;
    long offset;
    byond2PreprocLexer lexer;
    String name;
    static BaseErrorListener errorListener;

    FileState(String name) throws FileNotFoundException
    {
        file = new File(name);
        fs = new FileInputStream(file);
        offset = 0;
        lexer = lexerFactory();
        this.name = name;
    }

    FileState(InputStream fs)
    {
        this.fs = fs;
        offset = 0;
        lexer = lexerFactory();
    }

    // Each lexer store state for every included file
    private byond2PreprocLexer lexerFactory()
    {
        byond2PreprocLexer lexer = new byond2PreprocLexer(
                new UnbufferedCharStream(fs));
        lexer.setTokenFactory(new CommonTokenFactory(true));
        lexer.removeErrorListeners();
        lexer.addErrorListener(errorListener);
        return lexer;
    }

    void close() throws IOException
    {
        if (fs != System.in)
        {
            fs.close();
            fs = null;
        }
    }

    void reopen() throws FileNotFoundException, IOException
    {
        if (fs == null)
        {
            fs = new FileInputStream(file);
            fs.skip(offset);
        }
    }
}

class Preprocessor implements Runnable
{
    // Output text stream
    public PipedWriter pipe = new PipedWriter();

    private FileState file;
    private Stack<FileState> files = new Stack<FileState>();

    // Current macro
    private Vector<Token> macro = new Vector<Token>();
    
    private Vector<String> paths = new Vector<String>();

    private byond2ErrorListener errorListener = new byond2ErrorListener(
            () -> file.name );

    Preprocessor(InputStream is) throws IOException
    {
        FileState.errorListener = errorListener;
        file = new FileState(is);
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
            FileState tryFile = new FileState(longName);
            files.push(file);
            file = tryFile;
            pipe.write(String.format("\n#line 1 \"%s\"\n", file.name));
            // no need for additional \n cause it's added after #include ... \n
        }
        catch (IOException e) { }
    }

    private void evalMacro()
    {
        byond2MacroEval e = new byond2MacroEval(errorListener);
        String name = e.eval(macro);
        if (name != null)
        {
            include(name);
        }
    }

    private void flushMacro()
    {
        evalMacro();
        macro.clear();
    }

    private boolean consume() throws IOException
    {
        Token token = file.lexer.nextToken();
        int type = token.getType();

        switch (type)
        {
            //case byond2PreprocLexer.ID:
            //token = new CommonToken(token.getType(),
            //"[:ID[" + token.getText() + "]:]");

            case Token.EOF:
                if (!macro.isEmpty())
                {
                    file.lexer.popMode();
                    flushMacro();
                }

                if (!files.empty())
                {
                    file = files.pop();
                    pipe.write(String.format("\n\n#line %d \"%s\"\n",
                                file.lexer.getLine(),
                                file.name));
                    return true;
                }
                break;

            default:
                if (file.lexer._mode == file.lexer.Macro)
                {
                    macro.add(token);
                }
                else
                {
                    if (!macro.isEmpty())
                    {
                        // popMode() called by Lexer in NL handler
                        flushMacro();
                    }
                    pipe.write(token.getText());
                }
        }

        return type != Token.EOF;
    }
}
