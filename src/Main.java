import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import java.io.File;
import java.io.InputStream;
import java.io.FileInputStream;
import java.io.PipedReader;
import java.io.PipedWriter;
import java.io.BufferedReader;
import java.util.ArrayList;

class Main
{
    public static void main(String[] args) throws Exception
    {
        InputStream is;
        long inputLength = 1;

        boolean optionPreprocessOnly = false;
        boolean optionDoNotPreprocess = false;
        boolean optionShowTree = false;

        ArrayList<String> searchPathList = new ArrayList<String>();

        for (String opt : args)
        {
            if (opt.equals("-p"))
            {
                optionPreprocessOnly = true;
            }
            else if (opt.equals("-d"))
            {
                optionDoNotPreprocess = true;
            }
            else if (opt.equals("-t"))
            {
                optionShowTree = true;
            }
            else if (opt.startsWith("-I"))
            {
                searchPathList.add(opt.substring(2).trim());
            }
        }

        if (optionPreprocessOnly
                && optionDoNotPreprocess)
        {
            throw new RuntimeException("Exclusive options");
        }

        if (args.length > 0)
        {
            FileInputStream fis = new FileInputStream(
                    Preprocessor.search(args[args.length - 1], searchPathList));
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
            preproc.setSearchPathList(searchPathList);
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

            DMLexer lexer = new DMLexer(cs);
            lexer.removeErrorListeners();
            lexer.addErrorListener(new ErrorListener(
                        () -> lexer.getSourceName()));

            TokenStream tokens = new CommonTokenStream(lexer);

            DMParser parser = new DMParser(tokens);
            parser.setErrorHandler(new ReportError());
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
