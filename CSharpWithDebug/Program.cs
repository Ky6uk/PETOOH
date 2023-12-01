using petooh;

args = new []{"c:\\dev\\ttt\\PETOOH\\CSharpWithDebug\\bin\\Debug\\net8.0\\hello.koko", "-d"};

if (args.Length > 0)
{
    try
    {
        var interpreter = new Interpreter();
        interpreter.Load(File.ReadAllText(args[0]));
        IRunner runner = args.Contains("-d") ? new DebugRunner() : new NormalRunner();
        runner.Run(interpreter);
    }
    catch (Exception ex)
    {
        Console.WriteLine(ex);
    }
}
else
{
    Console.WriteLine("    USAGE: dotnet petooh.dll /path/to/file.koko [-d]");
    Console.WriteLine("         -d     add this option to debug");
}
