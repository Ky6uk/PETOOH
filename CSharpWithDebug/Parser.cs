namespace petooh;

public static class Parser
{
    public static string[] ToLexemes(string text)
    {
        var validChars = new HashSet<char>(
            Language.OP_DECPTR.ToCharArray()
                .Union(Language.OP_INCPTR.ToCharArray())
                .Union(Language.OP_INC.ToCharArray())
                .Union(Language.OP_DEC.ToCharArray())
                .Union(Language.OP_OUT.ToCharArray())
                .Union(Language.OP_JMP.ToCharArray())
                .Union(Language.OP_RET.ToCharArray()));

        var lexemes = new List<string>();
        string buf = "";
        bool wait = false;
        foreach (var ch in text)
        {
            if (!validChars.Contains(ch))
                continue;

            if (wait && ch != 'a')
            {
                lexemes.Add(buf);
                buf = "";
                wait = false;
            }
            else
            {
                wait = false;
            }

            var cmd = buf + ch;
            if (cmd is Language.OP_INC
                or Language.OP_DEC
                or Language.OP_OUT
                or Language.OP_INCPTR
                or Language.OP_DECPTR
                or Language.OP_JMP
                or Language.OP_RET)
            {
                if (cmd is Language.OP_JMP or Language.OP_RET)
                {
                    wait = true;
                    buf += ch;
                }
                else
                {
                    lexemes.Add(cmd);
                    buf = "";
                }
            }
            else
            {
                buf += ch;
            }
        }

        return lexemes.ToArray();
    }
}
