import org.antlr.v4.runtime.*;

class Main {
    public static void main(String[] args) throws Exception {
        ANTLRInputStream input;
        if (args.length > 0)
            input = new ANTLRFileStream(args[0]);
        else
            input = new ANTLRInputStream(System.in); 
        byond2Lexer lexer = new byond2Lexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        byond2Parser parser = new byond2Parser(tokens);
        parser.setBuildParseTree(true);
        RuleContext tree = parser.file();
        tree.inspect(parser); // show in gui
        //tree.save(parser, "/tmp/R.ps"); // Generate postscript
      //  System.out.println(tree.toStringTree(parser));
    }
}
