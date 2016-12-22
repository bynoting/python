#!/usr/bin/env python
import os

def Statistics(aRoot):
    vloume_limit = 200  #200M
    for rootpath,dirname,filename in os.walk(aRoot):
        for file in filename:
            filesize  = round((os.path.getsize(file)/1024/1024),4)
            print "filename is "+ file + " filesize is " + str(filesize)
       # if filesize > 500*1000

if __name__ =="__main__":
    import traceback
    try:
        Statistics(os.path.curdir)
    except Exception, e:
        print e.message



