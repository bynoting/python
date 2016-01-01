#! /usr/bin/env python
#coding=gbk
# process 版
import os
from multiprocessing import Pool
import multiprocessing as mul
from subprocess import *
import time

FFtoolFilePath = r'i:\Research\ffmpeg-20150714-git-dfc5858-win32-shared\bin\ffmpeg.exe'
ConverDir = r'i:\Research\ffmpeg-20150714-git-dfc5858-win32-shared\bin\1'

class ConverInfor():
    def __init__(self):
        self.InFile = ''
        self.ToolPath = ''
        self.OutFile = ''


def main():
    tstart1 = time.time()

    convertList = []

    for name in os.listdir(ConverDir):
        converInfor = ConverInfor()
        converInfor.InFile = os.path.join(ConverDir,name)
        converInfor.OutFile =  os.path.join(ConverDir, os.path.splitext(name)[0] +'.mp4')
        converInfor.ToolPath = FFtoolFilePath
        convertList.append(converInfor)
  
    cpuCount = mul.cpu_count()
    pool = Pool(cpuCount)
    pool.map(ConvertRun,convertList)
    pool.close()
    pool.join()
            
    tinterval = time.time() -tstart1
    print tinterval
    
    input("It's ok!")
    
def ConvertRun(aConverInfor):
    data = Popen(aConverInfor.ToolPath+' -i '+ aConverInfor.InFile+' -vf scale=320:240 -acodec aac -strict -2\
                    -vcodec mpeg4 -y '+aConverInfor.OutFile,stdout=PIPE,shell=True)

    print data.stdout.read()
    

    
if __name__=="__main__":
    import traceback
    try:        
        main()
    except Exception ,e:
        f = open('mytmdjsjFile-error.txt','w')
        traceback.print_exc( file = f )
        f.flush()
        f.close()
        print "出现异常：",e





