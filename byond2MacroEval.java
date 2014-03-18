import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.util.*;

class byond2MacroEval
{
    private String name;
    
    public String eval(Vector<Token> macro)
    {
        ListTokenSource macroStream = new ListTokenSource(macro);
        CommonTokenStream macroTokens = new CommonTokenStream(macroStream);
        byond2Preproc parser = new byond2Preproc(macroTokens);
        //parser.setBuildParseTree(false);
        //parser.removeErrorListeners();
        //parser.addErrorListener(errorListener);
        //parser.removeParseListeners();
        //parser.addParseListener(new byond2MacroListener());
        RuleContext tree = parser.macro();
        
        ParseTreeWalker walker = new ParseTreeWalker();

        byond2MacroListener listener = new byond2MacroListener();
        walker.walk(listener, tree);

        if (listener.result instanceof IncludeRel)
            name = ((IncludeRel) (listener.result)).name;

        return name;
    }
}
