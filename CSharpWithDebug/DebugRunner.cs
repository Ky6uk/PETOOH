using System.Text;

namespace petooh;

public class DebugRunner : IRunner
{
    private readonly StringBuilder _out = new();

    private void PrintStructured(IEnumerable<string> lexemes, int pc)
    {
        int counter = 0;
        int shift = 0;
        var split = "";
        foreach (var lexeme in lexemes)
        {
            var print = lexeme;
            if (counter == pc)
                print = $"|{lexeme}|";
            if (lexeme == Language.OP_JMP)
                shift++;
            if (lexeme == Language.OP_RET)
                shift--;
            if (lexeme is Language.OP_RET or Language.OP_JMP)
            {
                print = $"\n{print}\n";
                if (lexeme == Language.OP_RET)
                    print += "\n";
                Console.Write(print + new string(' ', shift * 2));
                split = "";
            }
            else
            {
                Console.Write(split + print);
                split = " ";
            }

            counter++;
        }
        Console.WriteLine();
    }

    private void PrintDebug(Interpreter interpreter)
    {
        var dbg = "nop";
        if (interpreter.ProgramPointer < interpreter.Lexemes.Length)
            dbg = interpreter.Lexemes[interpreter.ProgramPointer];

        Console.Clear();

        PrintStructured(interpreter.Lexemes, interpreter.ProgramPointer);

        Console.WriteLine($"\noutput: {_out}");
        Console.WriteLine("pc = " + interpreter.ProgramPointer + " |" + dbg +"|");
        Console.WriteLine("mem ptr = " + interpreter.MemoryPointer);
        Console.Write("memory:");
        for (int i = 0; i < interpreter.Memory.Count; i++)
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

    public void Run(Interpreter interpreter)
    {
        do
        {
            PrintDebug(interpreter);
        } while (interpreter.Next(Output));

        PrintDebug(interpreter);
    }
}
