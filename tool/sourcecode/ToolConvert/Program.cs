using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ToolConvert
{
   class Program
   {
      static void Main(string[] args)
      {
         List<string> strs = File.ReadAllLines("onevent.inc").ToList();
         List<string> temp = new List<string>();
         foreach(string str in strs)
         {
            string tempstr = str;
            if(str.StartsWith("if (strcmp(cmd,") || str.StartsWith("if (strcmp(cmdtext,") || str.StartsWith("if (!strcmp(cmdtext,"))
            {
               string key = str.Substring(str.IndexOf("/"), (str.IndexOf("true") - 3 - str.IndexOf("/"))).Replace("/","");
               tempstr = "cmd:" + key + "(playerid, params[])";
            }
            temp.Add(tempstr);
         }
         File.WriteAllLines("onevent.inc", temp.ToArray());
      }
   }
}
