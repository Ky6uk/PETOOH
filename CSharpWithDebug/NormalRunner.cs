using petooh;

public class NormalRunner : IRunner
{
    public void Run(Interpreter interpreter)
    {
        while (interpreter.Next(Console.Write))
        {
        }
    }
}