import java.io.*;
import java.util.*;

class FileState
{
    FileState(String name) throws FileNotFoundException
    {
        this.name = name;
        file = new File(name);
        fs = new FileInputStream(file);
        offset = 0;
    }

    FileState(InputStream fs)
    {
        this.fs = fs;
        offset = 0;
    }

    void close() throws IOException
    {
        if (fs != System.in)
        {
            fs.close();
            fs = null;
        }
    }

    void reopen() throws FileNotFoundException, IOException
    {
        if (fs == null)
        {
            fs = new FileInputStream(file);
            fs.skip(offset);
        }
    }

    String name;
    File file;
    InputStream fs;
    long offset;
}

public class IncludeStream extends InputStream 
{
    private Stack<FileState> files = new Stack<FileState>();
    FileState file = null;

    IncludeStream(String name) throws FileNotFoundException
    {
        file = new FileState(name);
    }

    IncludeStream(InputStream is) throws FileNotFoundException
    {
        file = new FileState(is);
    }

    public void include(String name) throws IOException
    {
        FileState tryFs = new FileState(name);
        files.push(file);
        file = tryFs;
    }

    @Override
    public int read() throws IOException, FileNotFoundException
    {
        int b = file.fs.read();

        if (b == -1 && !files.empty())
        {
            file = files.pop();
            file.reopen();
        }

        return b;
    }
}


