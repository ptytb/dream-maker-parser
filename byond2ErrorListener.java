import org.antlr.v4.runtime.*;

class byond2ErrorListener extends BaseErrorListener
{
    interface GetSourceName
    {
	String get();
    }

    private GetSourceName getSourceName;

    byond2ErrorListener(GetSourceName sn)
    {
        this.getSourceName = sn;
    }

    @Override
    public void syntaxError(
               Recognizer<?,?> recognizer,
               Object offendingSymbol,
               int line,
               int charPositionInLine,
               String msg,
               RecognitionException e)
    {
        System.err.println(getSourceName.get() + " line " + line + ", char "
                + charPositionInLine + " " + msg);
    }
}

