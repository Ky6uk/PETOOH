namespace petooh;

public class Interpreter
{
    private readonly List<byte> _memory = new(new byte[16]);
    public IReadOnlyList<byte> Memory => _memory;
    public int MemoryPointer { get; private set; }
    public int ProgramPointer { get; private set; }
    public string[] Lexemes { get; private set; } = Array.Empty<string>();

    public void Load(string code)
    {
        Lexemes = Parser.ToLexemes(code);
    }

    void IncMemPtr()
    {
        if (MemoryPointer == _memory.Count - 1)
            _memory.AddRange(new byte[16]);
        MemoryPointer++;
    }

    void DecMemPtr()
    {
        MemoryPointer--;
    }

    public bool Next(Action<string> output)
    {
        if (ProgramPointer >= Lexemes.Length)
            return false;

        switch (Lexemes[ProgramPointer])
        {
            case Language.OP_INC:_memory[MemoryPointer]++; break;
            case Language.OP_DEC:_memory[MemoryPointer]--; break;
            case Language.OP_INCPTR: IncMemPtr(); break;
            case Language.OP_DECPTR: DecMemPtr(); break;
            case Language.OP_OUT: output(((char)_memory[MemoryPointer]).ToString()); break;
            case Language.OP_JMP:
                if (_memory[MemoryPointer] == 0)
                {
                    var count = 1;
                    do
                    {
                        ProgramPointer++;
                        if (Lexemes[ProgramPointer] == Language.OP_JMP) count++;
                        if (Lexemes[ProgramPointer] == Language.OP_RET) count--;
                    } while (count > 0);
                }
                break;
            case Language.OP_RET:
                if (_memory[MemoryPointer] != 0)
                {
                    var count = 0;
                    do
                    {
                        if (Lexemes[ProgramPointer] == Language.OP_JMP) count++;
                        if (Lexemes[ProgramPointer] == Language.OP_RET) count--;
                        ProgramPointer--;
                    } while (count < 0);

                    ProgramPointer += 1;
                }
                break;
        }

        ProgramPointer++;

        return ProgramPointer < Lexemes.Length;
    }
}
