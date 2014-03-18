import org.antlr.v4.runtime.*;

class IncludeRel
{
    IncludeRel(String name)
    {
        this.name = name;
    }

    String name;
}

class byond2MacroListener extends byond2PreprocBaseListener
{
    Object result;

    @Override
    public void enterMacro_include_rel(
            byond2Preproc.Macro_include_relContext ctx)
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

