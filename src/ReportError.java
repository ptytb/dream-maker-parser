import org.antlr.v4.runtime.*;

class ReportError extends DefaultErrorStrategy
{
    public void reportError(Parser recognizer,
            RecognitionException e)
    {
        Token token = e.getOffendingToken();
        System.err.printf("%s ", token.getTokenSource().getSourceName());
        super.reportError(recognizer, e);
    }
}
