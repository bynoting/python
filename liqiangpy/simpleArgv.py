# -*- coding: utf-8 -*-
'''
Created on 2013-3-20

@author: lq
'''
 

import os ,sys
print (sys.argv)

def cdWalker(cdrom,cdcfile): 
    export = "" 
    for root, dirs, files in os.walk(cdrom): 
        export+="\n %s;%s;%s" % (root,dirs,files) 
        open(cdcfile, 'w').write(export)
        
if len(sys.argv)<2 :
    print("argv number not enoph")
    sys.exit(0)
    
if "-e"==sys.argv[1]:
    cdWalker("c:\\java",sys.argv[2])
    print("%s is write "%sys.argv[2])
else:
    print("CMD is   python pycdc.py -e mycd1-1.cdc")          
#cdWalker('C:\\Java','cd1.cdc') 
