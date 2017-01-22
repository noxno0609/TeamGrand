using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace SplitCode
{
    class Program
    {

        static void Main(string[] args)
        {
            SplitProject(); 
        }

        public static void SplitProject()
        {
            const string filename = "larpmerge.pwn";

            try
            {
                var content = File.ReadAllLines(filename).ToList();
                var arrayIndex =
                    Enumerable.Range(0, content.Count)
                        .Where(x => content[x].StartsWith("//") && content[x].EndsWith("TM"))
                        .ToList();
               for(var i = 0; i < arrayIndex.Count; i++)
               {
                   var fileName = content.ElementAt(arrayIndex[i]).Replace("//", "").Replace(" TM", "");
                   File.WriteAllLines(fileName,
                       arrayIndex[i] == arrayIndex.Last()
                           ? content.GetRange(arrayIndex[i] + 1, content.Count - arrayIndex[i] - 1)
                           : content.GetRange(arrayIndex[i] + 1, arrayIndex[i + 1] - arrayIndex[i] - 1));
               }
            }
            catch (Exception ex)
            {
                Console.WriteLine("\nError");
                Console.WriteLine(ex);
                Console.ReadKey();
            }
        }
    }
}
