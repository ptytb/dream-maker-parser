import org.antlr.v4.runtime.*;
import java.util.Calendar;

class MyParserListener extends byond2ParserBaseListener
{
    private long inputLength;
    private long offset_prev = 0;
    private long count = 0;
    private long time;

    MyParserListener(long inputLength)
    {
        this.inputLength = inputLength;
    }

    private String time(float t)
    {
        if (t < 60)
            return String.format("%.2f sec", t);
        else if (t < 3600)
            return String.format("%.2f min", t / 60.);
        else
            return String.format("%.2f h", t / 3600.);
    }

    @Override
    public void exitEveryRule(ParserRuleContext ctx)
    {
        if (ctx == null || ctx.stop == null)
            return;

        long offset = ctx.stop.getStopIndex();
        count += offset - offset_prev;

        if (count > 100000)
        {
            float speedBps = (float) count * 1000 /
                    (Calendar.getInstance().getTimeInMillis() - time);
            System.out.printf("%d of %d, %f%%, %.2f bps, %s remaining\n"
                    , offset
                    , inputLength
                    , (float) offset / inputLength
                    , speedBps
                    , time(inputLength / speedBps));

            count = 0;
            time = Calendar.getInstance().getTimeInMillis();
        }
        offset_prev = offset;
    }
}

