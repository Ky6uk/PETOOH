using System.Text;

namespace petooh;

public class DebugRunner : IRunner
{
    private readonly StringBuilder _out = new();

    private void PrintDebug(Interpreter interpreter)
    {
        var dbg = "nop";
        if (interpreter.ProgramPointer < interpreter.Lexemes.Length)
            dbg = ToDbg(interpreter.Lexemes[interpreter.ProgramPointer]);

        var dbgs = interpreter.Lexemes.Select(ToDbg).ToArray();

        Console.Clear();
        Console.WriteLine(string.Join(" ", dbgs.Select((x, i) => i == interpreter.ProgramPointer ? $"|{x}|":x)));
        Console.WriteLine($"output: {_out}");
        Console.WriteLine("pc = " + interpreter.ProgramPointer + " |" + dbg +"|");
        Console.WriteLine("mem ptr = " + interpreter.MemoryPointer);
        Console.Write("memory:");
        for (int i = 0; i < interpreter.MemoryPointer + 50; i++)
        {
            Console.Write(i == interpreter.MemoryPointer ? $" |{interpreter.Memory[i]}|" : $" {interpreter.Memory[i]}");
        }

        if (interpreter.ProgramPointer >= interpreter.Lexemes.Length)
            Console.WriteLine("\nProgram finished. Press any key to exit...");
        else
            Console.WriteLine("\npress any key to next step...");

        Console.ReadKey();
    }

    private void Output(string str)
    {
        _out.Append(str);
    }

    private static string ToDbg(string x) => x switch
    {
        Language.OP_INC => "+",
        Language.OP_DEC => "-",
        Language.OP_OUT => "O",
        Language.OP_INCPTR => "->",
        Language.OP_DECPTR => "<-",
        Language.OP_JMP => "(",
        Language.OP_RET => ")",
    };

    public void Run(Interpreter interpreter)
    {
        do
        {
            PrintDebug(interpreter);
        } while (interpreter.Next(Output));

        PrintDebug(interpreter);
    }
}
