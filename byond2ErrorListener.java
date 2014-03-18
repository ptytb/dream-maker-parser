import org.antlr.v4.runtime.*;

class byond2ErrorListener extends BaseErrorListener
{
    FileNameBinding fb;

    byond2ErrorListener(FileNameBinding fb)
    {
        this.fb = fb;
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
        System.err.println(fb.fileName + "line " + line + ", char "
                + charPositionInLine + " " + msg);
    }

    static class FileNameBinding
    {
        String fileName;
    }
}

