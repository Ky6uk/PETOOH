namespace petooh;

public class Interpreter
{
    private const int MAX_MEM = 65535;

    private readonly byte[] _memory = new byte[MAX_MEM];
    public IReadOnlyList<byte> Memory => _memory;
    public int MemoryPointer { get; private set; }
    public int ProgramPointer { get; private set; }
    public string[] Lexemes { get; private set; }

    public void Load(string code)
    {
        Lexemes = Parser.ToLexemes(code);
    }

    public bool Next(Action<string> output)
    {
        if (ProgramPointer >= Lexemes.Length)
            return false;

        switch (Lexemes[ProgramPointer])
        {
            case Language.OP_INC:_memory[MemoryPointer]++; break;
            case Language.OP_DEC:_memory[MemoryPointer]--; break;
            case Language.OP_INCPTR: MemoryPointer++; break;
            case Language.OP_DECPTR: MemoryPointer--; break;
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
