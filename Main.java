import org.antlr.v4.runtime.*;
import java.io.*;

class Main
{
    public static void main(String[] args) throws Exception
    {
        IncludeStream is;

        if (args.length > 0)
            is = new IncludeStream(args[0]);
        else
            is = new IncludeStream(System.in);

        Preprocessor preproc = new Preprocessor(is);
        PipedReader pipe = new PipedReader(preproc.pipe);
        Thread t = new Thread(preproc, "Preprocessor");
        t.start();

        byond2Lexer lexer = new byond2Lexer(new ANTLRInputStream(pipe));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        byond2Parser parser = new byond2Parser(tokens);

        //parser.setBuildParseTree(true);
        RuleContext tree = parser.file();
        tree.inspect(parser); // show in gui
        //tree.save(parser, "/tmp/R.ps"); // Generate postscript
        //System.out.println(tree.toStringTree(parser));
    }
}
