import org.antlr.v4.runtime.*;
import java.io.*;

class Main
{
    public static void main(String[] args) throws Exception
    {
        InputStream is;

        boolean optionPreprocessOnly = false;

        if (args.length > 0)
            is = new FileInputStream(args[0]);
        else
            is = System.in;

        Preprocessor preproc = new Preprocessor(is);
        preproc.addSearchPath("/media/usb3/Baystation12/Baystation12");
        PipedReader pipe = new PipedReader(preproc.pipe);
        Thread t = new Thread(preproc, "Preprocessor");
        t.start();

        if (!optionPreprocessOnly)
        {
            byond2Lexer lexer = new byond2Lexer(new UnbufferedCharStream(pipe));
            lexer.setTokenFactory(new CommonTokenFactory(true));
            UnbufferedTokenStream tokens = new UnbufferedTokenStream(lexer);
            byond2Parser parser = new byond2Parser(tokens);
            //parser.setBuildParseTree(false);
            parser.removeParseListeners();
            RuleContext tree = parser.file();
            tree.inspect(parser); // show in gui
            //tree.save(parser, "/tmp/R.ps"); // Generate postscript
            //System.out.println(tree.toStringTree(parser));
        }
        else
        {
            BufferedReader br = new BufferedReader(pipe);
            String line;
            while ((line = br.readLine()) != null)
            {
                System.out.println(line);
            }
        } 
    }
}
