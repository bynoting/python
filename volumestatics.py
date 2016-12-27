#!/usr/bin/env python
#coding=utf8
import os

def Statistics(aRoot):
    vloume_limit = 200 *1024 * 1024 #200M

    for rootpath,dirs,files in os.walk(aRoot):
        for file in files:
            filesize  = os.path.getsize(file)
            print "filename is {fname},filesize={fsize}".format(fname=file,fsize=filesize)
       # if filesize > 5

if __name__ =="__main__":
    import traceback
    try:
        Statistics(os.path.curdir)
    except Exception, e:
        print e.message



