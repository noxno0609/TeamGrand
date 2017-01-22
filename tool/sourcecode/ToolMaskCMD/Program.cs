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
            maskInfo.Add("deny", false);
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
               Hashtable maskInfo = (Hashtable)entry.Value;
               string cmdsource = "CMD:" + Convert.ToString(entry.Key) + "(";
               string cmdmask = "CMD:" + Convert.ToString(maskInfo["mask"]) + "(";
               if(filecontent.ToLower().Contains(cmdsource.ToLower()) && Convert.ToBoolean(maskInfo["deny"]) == false)
               {
                  string contentcmd = cmdmask + "playerid, params[]) { return cmd_" + Convert.ToString(entry.Key) + "(playerid, params); }";
                  result.Add(contentcmd);

                  int countmask = Convert.ToInt32(maskInfo["count"]);
                  countmask++;

                  maskInfo["count"] = countmask;

                  Console.WriteLine("Add mask line " + count);
               }
               else if(filecontent.ToLower().Contains(cmdmask.ToLower()))
               {
                  bool denybool = Convert.ToBoolean(maskInfo["deny"]);
                  denybool = true;
                  maskInfo["deny"] = denybool;
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
            else if(Convert.ToBoolean(maskInfo["deny"]) == true)
            {
               contentlogs.Add(Convert.ToString(entry.Key) + " - CMD has already existed!");
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
