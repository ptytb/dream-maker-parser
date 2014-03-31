import org.antlr.v4.runtime.*;

class IncludeRel
{
    IncludeRel(String name)
    {
        this.name = name;
    }

    String name;
}

class MacroListener extends PreprocBaseListener
{
    Object result;

    @Override
    public void enterMacroIncludeRel(Preproc.MacroIncludeRelContext ctx)
    {
        String text = ctx.getText().substring(7);
        text = text.replace("\\", "/");
        if (text.length() > 1
                && text.startsWith("\"")
                && text.endsWith("\""))
        {
            text = text.substring(1, text.length() - 1);
        }

        result = new IncludeRel(text);
    }
}

