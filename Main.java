import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import java.io.*;

class Main
{
    public static void main(String[] args) throws Exception
    {
        InputStream is;
        long inputLength = 1;

        boolean optionPreprocessOnly = false;
        boolean optionDoNotPreprocess = false;
        boolean optionShowTree = false;

        if (optionPreprocessOnly
                && optionDoNotPreprocess)
        {
            throw new RuntimeException("Exclusive options");
        }

        if (args.length > 0)
        {
            FileInputStream fis = new FileInputStream(args[0]);
            inputLength = fis.getChannel().size();
            is = fis;
        }
        else
        {
            is = System.in;
        }

        PipedReader pipe = null;
        if (!optionDoNotPreprocess)
        {
            Preprocessor preproc = new Preprocessor(is);
            preproc.addSearchPath("/media/usb3/Baystation12/Baystation12");
            pipe = new PipedReader(preproc.pipe);
            Thread t = new Thread(preproc, "Preprocessor");
            t.start();
        }

        if (!optionPreprocessOnly)
        {
            CharStream cs = null;
            if (optionDoNotPreprocess)
            {
                cs = new ANTLRInputStream(is);
            }
            else
            {
                cs = new ANTLRInputStream(pipe);
            }

            byond2Lexer lexer = new byond2Lexer(cs);
            lexer.removeErrorListeners();
            lexer.addErrorListener(new byond2ErrorListener(
                        () -> lexer.getSourceName()));

            TokenStream tokens = new CommonTokenStream(lexer);

            byond2Parser parser = new byond2Parser(tokens);
            parser.setErrorHandler(new byond2ReportError());
            parser.getInterpreter().setPredictionMode(PredictionMode.SLL);
            parser.setBuildParseTree(optionShowTree);
            parser.removeParseListeners();
            //parser.addParseListener(new MyParserListener(inputLength));

            RuleContext tree = parser.file();

            if (optionShowTree)
            {
                tree.inspect(parser); // show in gui
            }
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
