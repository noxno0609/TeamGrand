using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;

namespace MergeCode
{
   class Program
   {
      
      static void Main(string[] args)
      {
         mergeProject();
         runServer();
      }

      public static void mergeProject()
      {
         List<string> mergecontents = new List<string>();

         string pathsen = "../gamemodes/larp.pwn";
         addToMerge(mergecontents, new FileInfo(pathsen), pathsen);

         pathsen = "../pawno/include/ProjectInc";
         FileInfo[] projectinc = new DirectoryInfo(pathsen).GetFiles();
         foreach(FileInfo file in projectinc)
         {
            addToMerge(mergecontents, file, pathsen);
         }

         if(File.Exists("../servicer/larpmerge.pwn"))
            File.Delete("../servicer/larpmerge.pwn");

         using (TextWriter tw = new StreamWriter("../servicer/larpmerge.pwn", true))
         {
            foreach(string mergecontent in mergecontents)
            {
               tw.WriteLine(mergecontent);
            }
         }
         Console.WriteLine("\n--> Merge done! Create file full merge code in larpmerge.pwn on servicer folder");
         System.Threading.Thread.Sleep(2500);
      }

      public static void addToMerge(List<string> mergecontents, FileInfo file, string pathsen)
      {
         mergecontents.Add("//" + pathsen + " TM");
         
         List<string> contents = File.ReadAllLines(file.FullName).ToList();
         foreach (string content in contents)
         {
            mergecontents.Add(content);
         }
         Console.WriteLine("Add " + file.Name + " to merge source!");
      }

      public static void runServer()
      {
         if (File.Exists("../gamemodes/larp.amx"))
            File.Delete("../gamemodes/larp.amx");

         File.Move("larp.amx", "../gamemodes/larp.amx");

         if (Process.GetProcessesByName("samp-server").Length > 0)
         {
            Console.WriteLine("\nServer is starting...! You can't close server first and start it!");
            Console.ReadKey();
            return;
         }

         string path = Directory.GetCurrentDirectory();
         string samppath = Path.GetFullPath(Path.Combine(path, @"../"));

         Process process = new Process();
         process.StartInfo.FileName = samppath + "/samp-server.exe";
         process.StartInfo.WorkingDirectory = samppath;
         process.Start();
      }
   }
}
