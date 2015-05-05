using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace Petooh
{
    class Petooh
    {
        private List<string>[] stack = new List<string>[32000];
        private int level = 0;
        private int currentPosition = 0;
        private string word = string.Empty;
        private Regex filter = new Regex(@"[^adehkKoOru]");

        private int?[] brain = new int?[1 << 16 - 1];
        private string result = string.Empty;

        private Dictionary<string, Action> OpCodes { get; set; }

        public Petooh()
        {
            OpCodes = new Dictionary<string, Action>
                      {
                          {"Ko",()=>IncreasePlz()},
                          {"kO",()=>DecreasePlz()},
                          {"Kudah",()=>++currentPosition},
                          {"kudah",()=>--currentPosition},
                          {"Kukarek",()=>Success()}
                      };
        }

        // ears of your rooster
        public void Listen(string sound)
        {
            sound=filter.Replace(sound, "");
            foreach (var piece in sound.Select(x => x.ToString()))
            {
                var buffer = word + piece;

                if (word == "Kud" && piece != "a")
                {
                    stack[++level] = new List<string>();
                    Forget(piece);
                }
                else if (word == "kud" && piece != "a")
                {
                    Repeat();
                    --level;
                    Forget(piece);
                }
                else if (OpCodes.ContainsKey(buffer))
                {
                    if (level > 0)
                    {
                        Remember(buffer);
                    }
                    else
                    {
                        OpCodes[buffer]();
                    }

                    Forget(null);
                }
                else
                {
                    word += piece;
                }
            }
        }

        void Repeat()
        {
            while (brain[currentPosition] > 0)
            {
                foreach(var word in stack[level])
                {
                    if (OpCodes.ContainsKey(word))
                    {
                        OpCodes[word]();
                    }
                }
            }
        }

        // catch some error
        void PeckError()
        {
            throw new Exception("peck-peck");
        }

        void Forget(string sound)
        {
            word = sound ?? "";
        }

        void IncreasePlz()
        {
            brain[currentPosition] = (brain[currentPosition] ?? 0) + 1;
        }

        void DecreasePlz()
        {
            brain[currentPosition] = (brain[currentPosition] ?? 2) - 1;
        }

        void Remember(string word)
        {
            if (level >= stack.Length)
            {
                PeckError();
            }
            stack[level].Add(word);
        }

        void Success()
        {
            result += Convert.ToChar(brain[currentPosition]);
        }

        public string Told
        {
            get
            {
                return result;
            }
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length > 0)
            {
                var pet = new Petooh();

                pet.Listen(System.IO.File.ReadAllText(args[0]));
                Console.WriteLine(pet.Told);
            }
            else
            {
                Console.WriteLine("USAGE: Petooh.exe /path/to/file.koko");
            }
            Console.WriteLine();
            Console.WriteLine("Press ANY key");
            Console.ReadKey();
        }
    }
}
