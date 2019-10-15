

import pathlib
import re

f= open("ravi.csv","w+")
f.write("Bin,# Ts, # READS,\n")

py = pathlib.Path().glob("vaf/*.txt")
for file in py:
     filName = file.name.split("/")
     fname = filName[0].split("_")
     bin = fname[0]

     for line in open(file):
          if "226252135" in line:
        #       print(line)
               tTotREADS=line[14:]
               sTotREADS=tTotREADS[0:3]
               Ts=line.count('T') + line.count('t')

     f.write("%s,%s,%s,\n" % (bin, Ts, sTotREADS))
     print("%s,%s,%s,\n" % (bin, Ts, sTotREADS))

f.close()