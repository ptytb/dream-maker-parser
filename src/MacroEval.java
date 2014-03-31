import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.util.ArrayList;

class MacroEval
{
    private String name;

    private ErrorListener errorListener;

    MacroEval(ErrorListener el)
    {
	errorListener = el;
    }
    
    public String eval(ArrayList<Token> macro)
    {
        ListTokenSource macroStream = new ListTokenSource(macro);
        CommonTokenStream macroTokens = new CommonTokenStream(macroStream);
        Preproc parser = new Preproc(macroTokens);
        //parser.setBuildParseTree(false);
        parser.removeErrorListeners();
        parser.addErrorListener(errorListener);
        //parser.removeParseListeners();
        //parser.addParseListener(new MacroListener());
        RuleContext tree = parser.macro();
        
        ParseTreeWalker walker = new ParseTreeWalker();

        MacroListener listener = new MacroListener();
        walker.walk(listener, tree);

        if (listener.result instanceof IncludeRel)
            name = ((IncludeRel) (listener.result)).name;

        return name;
    }
}
