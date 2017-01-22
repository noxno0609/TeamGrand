using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace ToolSub
{
   class Program
   {
      static void Main(string[] args)
      {
         Hashtable subMap = new Hashtable();
         List<string> contents = File.ReadAllLines("sub.txt").ToList();

         File.Delete("errorlog.txt");
         File.Delete("logsub.txt");

         foreach (string content in contents)
         {
            if ("".Equals(content.Trim())) continue;
            if(checkCountNgoacKep(content) == false)
            {
               using (TextWriter tw = new StreamWriter("errorlog.txt", true))
               {
                  tw.WriteLine(content);
               }
               continue;
            }
            try
            {
               string pattern = "\"(.*?)\"";
               Regex reg = new Regex(pattern);
               Match matchsource = reg.Match(content);

               Hashtable subInfo = new Hashtable();
               subInfo.Add("usetime", 0);
               subInfo.Add("sub", matchsource.NextMatch().Value.Replace("\"", ""));
               subMap.Add(matchsource.Value.Replace("\"", ""), subInfo);
            }
            catch (Exception ex)
            {
               using (TextWriter tw = new StreamWriter("errorlog.txt", true))
               {
                  tw.WriteLine(content);
               }
            }
         }

         Console.WriteLine("Nhap ten file de replace sub: ");
         string filename = Console.ReadLine();
         List<string> modecontents = File.ReadAllLines(filename).ToList();
         List<string> result = new List<string>();

         int countline=0;
         foreach(string str in modecontents)
         {
            string strtemp = str;
            foreach(DictionaryEntry entry in subMap)
            {
               if(str.Contains(Convert.ToString(entry.Key)))
               {
                  Hashtable subinfo = (Hashtable) entry.Value;
                  int count = Convert.ToInt32(subinfo["usetime"]);
                  count++;
                  subinfo["usetime"] = count;

                  strtemp = strtemp.Replace(Convert.ToString(entry.Key),
                                    Convert.ToString(subinfo["sub"]));

                  Console.WriteLine("Sub line: " + countline);
               }
            }
            result.Add(strtemp);
            countline++;
         }
         File.WriteAllLines(filename, result.ToArray());

         List<string> contentlog = new List<string>();
         foreach(DictionaryEntry entry in subMap)
         {
            Hashtable subinfo = (Hashtable) entry.Value;
            int count = Convert.ToInt32(subinfo["usetime"]);
            if(count == 0)
            {
               contentlog.Add(Convert.ToString(entry.Key));
            }
         }

         using (TextWriter tw = new StreamWriter("logsub.txt", true))
         {
            foreach (string log in contentlog)
            {
               tw.WriteLine(log);
            }
         }

         Console.WriteLine("Replace all sub successfully. Press any key to continue...");
         Console.ReadKey();
      }

      public static bool checkCountNgoacKep(string content)
      {
         Regex reg = new Regex("[\"]");
         int count = reg.Matches(content).Count;
         if (count != 4) return false;
         return true;
      }
   }
}
