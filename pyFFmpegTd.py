#! /usr/bin/env python
#coding=gbk
# threading 版 目前速度较快
import os
import threading
import time
from subprocess import *


fftoolFilePath = r'g:\Research\ffmpeg-20150714-git-dfc5858-win32-shared\bin\ffmpeg.exe'
converDir = r'g:\Research\ffmpeg-20150714-git-dfc5858-win32-shared\bin\1'
ThreadNum = 3
threadFlagNum =0
threads = []
mutex = threading.Lock()
def main():

    tstart1 = time.time()
    global threads  
  
    fileList = os.listdir(converDir)
    fileNum = len(fileList)
    # python 三元表达式 取整
    #partNum = (fileNum/ThreadNum if fileNum%ThreadNum==0 else fileNum/ThreadNum+1)

    for name in fileList:
        if os.path.isdir(name):
            continue
        converFile = os.path.join(converDir,name)
        
        outFileName = os.path.join(converDir, os.path.splitext(name)[0] +'.mp4')

        t = threading.Thread(target = ConvertRun,args=(converFile,fftoolFilePath,outFileName))
       
        threads.append(t)
        t.setDaemon(True)
        t.start()
        
        global threadFlagNum
        mutex.acquire()
        threadFlagNum += 1
        mutex.release()

        # 推拉窗功能 等待控制并行线程数量
        while(True):
            if threadFlagNum <= ThreadNum :
                break

    for t in threads:
        t.join()

    tinterval = time.time() -tstart1
    print tinterval
    input("It's ok!")
    
    
def ConvertRun(aInFile,aToolPath,aOutfile): #,scale=320:240
    '''data = Popen(aToolPath+' -i '+ aInFile+' -qscale 6 -vf crop=768:576:128:0,scale=320:240 -acodec aac -strict -2\
                    -vcodec libxvid -y '+aOutfile,stdout=PIPE,shell=True)'''
    data = Popen(aToolPath+' -i '+ aInFile+' -qscale 6 -vf scale=320:240 -acodec aac -strict -2\
                        -vcodec libxvid -y '+aOutfile,stdout=PIPE,shell=True)
    
    print data.stdout.read()
    global threadFlagNum
    mutex.acquire()
    threadFlagNum -=1
    mutex.release()
    
    
        
    
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





