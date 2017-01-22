using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ToolMaskCMD
{
   class Program
   {
      static void Main(string[] args)
      {
         Hashtable cmdMap = new Hashtable();
         List<string> contents = File.ReadAllLines("maskcmd.txt").ToList();
         foreach(string content in contents)
         {
            string[] maskcmd = content.Split('-');
            Hashtable maskInfo = new Hashtable();
            maskInfo.Add("count", 0);
            maskInfo.Add("mask", maskcmd[1]);
            cmdMap.Add(maskcmd[0], maskInfo);
         }

         List<string> result = new List<string>();
         Console.WriteLine("Nhap ten file gamemode vao: ");
         string filename = Console.ReadLine();

         int count = 0;
         List<string> filecontents = File.ReadAllLines(filename).ToList();
         foreach(string filecontent in filecontents)
         {
            count++;
            foreach(DictionaryEntry entry in cmdMap)
            {
               string cmdsource = "CMD:" + Convert.ToString(entry.Key) + "(";
               if(filecontent.ToLower().Contains(cmdsource.ToLower()))
               {
                  Hashtable maskInfo = (Hashtable)entry.Value;
                  string cmdmask = "CMD:" + Convert.ToString(maskInfo["mask"]);
                  string contentcmd = cmdmask + "(playerid, params[]) { return cmd_" + Convert.ToString(entry.Key) + "(playerid, params); }";
                  result.Add(contentcmd);

                  int countmask = Convert.ToInt32(maskInfo["count"]);
                  countmask++;

                  maskInfo["count"] = countmask;

                  Console.WriteLine("Add mask line " + count);
               }
            }
            result.Add(filecontent);
         }

         File.WriteAllLines(filename, result.ToArray());

         List<string> contentlogs = new List<string>();
         foreach (DictionaryEntry entry in cmdMap)
         {
            Hashtable maskInfo = (Hashtable)entry.Value;
            if(Convert.ToInt32(maskInfo["count"]) == 0)
            {
               contentlogs.Add(Convert.ToString(entry.Key));              
            }
         }
         using (TextWriter tw = new StreamWriter("logmask.txt", true))
         {
            foreach (string contentlog in contentlogs)
            {
               tw.WriteLine(contentlog);
            }
         }
         Console.WriteLine("Complete add mask CMD...Type anything to close!");
         Console.ReadKey();
      }
   }
}
